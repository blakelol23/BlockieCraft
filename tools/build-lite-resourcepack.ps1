param(
  [string]$ProjectRoot=(Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
  [string]$SourcePackName="Minecraft Classic Edition",
  [string]$DestinationPackName="Minecraft Classic Edition Lite",
  [switch]$PruneDestination
)

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

function Get-TextureKeys {
  param(
    [Parameter(Mandatory=$true)][string]$IndexHtmlPath,
    [Parameter(Mandatory=$true)][string]$ConstName
  )
  $txt=Get-Content -Raw -Path $IndexHtmlPath
  $m=[regex]::Match($txt,"const\s+${ConstName}\s*=\s*\[(?<body>[\s\S]*?)\];")
  if(-not $m.Success){
    throw "Could not find array constant '$ConstName' in $IndexHtmlPath"
  }
  $keys=[regex]::Matches($m.Groups["body"].Value,'"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
  if(-not $keys -or $keys.Count -eq 0){
    throw "No keys found in array '$ConstName'"
  }
  return @($keys)
}

function Ensure-Dir {
  param([Parameter(Mandatory=$true)][string]$Path)
  if(-not (Test-Path -LiteralPath $Path)){
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Copy-KeySet {
  param(
    [Parameter(Mandatory=$true)][string]$SourceDir,
    [Parameter(Mandatory=$true)][string]$DestDir,
    [Parameter(Mandatory=$true)][string[]]$Keys,
    [Parameter(Mandatory=$true)][string]$Bucket,
    [System.Collections.Generic.HashSet[string]]$Wanted,
    [System.Collections.Generic.List[string]]$Missing
  )
  Ensure-Dir -Path $DestDir
  foreach($k in $Keys){
    $rel="assets/minecraft/textures/$Bucket/$k.png"
    [void]$Wanted.Add($rel)
    $src=Join-Path $SourceDir "$k.png"
    $dst=Join-Path $DestDir "$k.png"
    if(Test-Path -LiteralPath $src){
      if(-not (Test-Path -LiteralPath $dst) -or ((Get-Item -LiteralPath $src).Length -ne (Get-Item -LiteralPath $dst -ErrorAction SilentlyContinue).Length)){
        Copy-Item -LiteralPath $src -Destination $dst -Force
      }
    }else{
      [void]$Missing.Add("$Bucket/$k.png")
    }
  }
}

function Prune-Extras {
  param(
    [Parameter(Mandatory=$true)][string]$DestTexturesRoot,
    [Parameter(Mandatory=$true)][System.Collections.Generic.HashSet[string]]$Wanted
  )
  if(-not (Test-Path -LiteralPath $DestTexturesRoot)){return 0}
  $removed=0
  $sep=[System.IO.Path]::DirectorySeparatorChar
  $normRoot=(Resolve-Path -LiteralPath $DestTexturesRoot).Path.TrimEnd($sep)
  $all=Get-ChildItem -Path $DestTexturesRoot -File -Recurse
  foreach($f in $all){
    $relTex=$f.FullName.Substring($normRoot.Length+1).Replace($sep,'/')
    $rel="assets/minecraft/textures/$relTex"
    if(-not $Wanted.Contains($rel)){
      Remove-Item -LiteralPath $f.FullName -Force
      $removed++
    }
  }
  Get-ChildItem -Path (Split-Path -Parent $DestTexturesRoot) -Directory -Recurse |
    Sort-Object FullName -Descending |
    ForEach-Object {
      if(-not (Get-ChildItem -LiteralPath $_.FullName -Force | Select-Object -First 1)){
        Remove-Item -LiteralPath $_.FullName -Force
      }
    }
  return $removed
}

$indexPath=Join-Path $ProjectRoot "index.html"
if(-not (Test-Path -LiteralPath $indexPath)){
  throw "index.html not found at $indexPath"
}

$srcPackRoot=Join-Path $ProjectRoot "assets/resourcepacks/$SourcePackName"
$dstPackRoot=Join-Path $ProjectRoot "assets/resourcepacks/$DestinationPackName"
$srcBlock=Join-Path $srcPackRoot "assets/minecraft/textures/block"
$srcItem=Join-Path $srcPackRoot "assets/minecraft/textures/item"
$dstBlock=Join-Path $dstPackRoot "assets/minecraft/textures/block"
$dstItem=Join-Path $dstPackRoot "assets/minecraft/textures/item"

if(-not (Test-Path -LiteralPath $srcBlock)){ throw "Missing source block folder: $srcBlock" }
if(-not (Test-Path -LiteralPath $srcItem)){ throw "Missing source item folder: $srcItem" }

$blockKeys=Get-TextureKeys -IndexHtmlPath $indexPath -ConstName "RESOURCE_PACK_BLOCK_KEYS"
$itemKeys=Get-TextureKeys -IndexHtmlPath $indexPath -ConstName "RESOURCE_PACK_ITEM_KEYS"

Ensure-Dir -Path $dstBlock
Ensure-Dir -Path $dstItem

$wanted=[System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$missing=[System.Collections.Generic.List[string]]::new()

Copy-KeySet -SourceDir $srcBlock -DestDir $dstBlock -Keys $blockKeys -Bucket "block" -Wanted $wanted -Missing $missing
Copy-KeySet -SourceDir $srcItem -DestDir $dstItem -Keys $itemKeys -Bucket "item" -Wanted $wanted -Missing $missing

$removedCount=0
if($PruneDestination){
  $dstTexturesRoot=Join-Path $dstPackRoot "assets/minecraft/textures"
  $removedCount=Prune-Extras -DestTexturesRoot $dstTexturesRoot -Wanted $wanted
}

$copiedBlock=(Get-ChildItem -Path $dstBlock -File -Filter "*.png" -ErrorAction SilentlyContinue | Measure-Object).Count
$copiedItem=(Get-ChildItem -Path $dstItem -File -Filter "*.png" -ErrorAction SilentlyContinue | Measure-Object).Count

Write-Host "Built lite resource pack: $DestinationPackName"
Write-Host "  Source:      $srcPackRoot"
Write-Host "  Destination: $dstPackRoot"
Write-Host "  Block PNGs:  $copiedBlock"
Write-Host "  Item PNGs:   $copiedItem"
if($PruneDestination){ Write-Host "  Pruned files:$removedCount" }

if($missing.Count -gt 0){
  Write-Warning "Missing textures referenced by index.html ($($missing.Count)):"
  $missing | Sort-Object | ForEach-Object { Write-Host "  - $_" }
}
