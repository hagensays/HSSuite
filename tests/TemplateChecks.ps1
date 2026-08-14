$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $root 'src\HSTemplate'
$projectPath = Join-Path $sourceRoot 'HSTemplate.csproj'

if (-not (Test-Path $projectPath)) {
    throw 'HSTemplate project is missing.'
}

$project = Get-Content $projectPath -Raw
if ($project -notmatch '<TargetFrameworkVersion>v4\.7\.2</TargetFrameworkVersion>') {
    throw 'Template must target .NET Framework 4.7.2.'
}
if ($project -match '<PackageReference') {
    throw 'Template must not contain NuGet PackageReference dependencies.'
}

$sourceFiles = Get-ChildItem $sourceRoot -Recurse -File | Where-Object { $_.Extension -in '.cs', '.xaml' }
$forbiddenStorage = @(
    'Path.GetTempPath',
    'Environment.SpecialFolder.ApplicationData',
    'Environment.SpecialFolder.LocalApplicationData'
)
foreach ($needle in $forbiddenStorage) {
    $matches = $sourceFiles | Select-String -SimpleMatch $needle
    if ($matches) {
        throw "Template source uses forbidden default storage API '$needle'."
    }
}

$outputService = Get-Content (Join-Path $sourceRoot 'Infrastructure\OutputPathService.cs') -Raw
if ($outputService -notmatch 'AppDomain\.CurrentDomain\.BaseDirectory') {
    throw 'OutputPathService must root generated output beside the executable.'
}
if ($outputService -notmatch 'FileMode\.CreateNew') {
    throw 'OutputPathService must expose non-overwriting CreateNew output.'
}

foreach ($required in @('Themes\Colors.xaml', 'Themes\Controls.xaml', 'MainWindow.xaml')) {
    if (-not (Test-Path (Join-Path $sourceRoot $required))) {
        throw "Required suite UI file missing: $required"
    }
}

Write-Host 'HSSuite template invariants passed.'
