################################################################################
##  File:  Install-BizTalkBuildComponent.ps1
##  Desc:  Install BizTalk Project Build Component
################################################################################
if (Test-IsWin19) {
    # If Windows 2019, BIZtalk Project Build Component is not supported temporary solution
    $downloadUrl = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-biztalk/vsextensions/BizTalk/3.13.2.0/vspackage"
    $signatureThumbprint = "8740DF4ACB749640AD318E4BE842F72EC651AD80"
} else {
    $downloadUrl = "https://aka.ms/BuildComponentSetup.EN"
    $signatureThumbprint = "8740DF4ACB749640AD318E4BE842F72EC651AD80"
}

Write-Host "Downloading BizTalk Project Build Component archive..."
$zipFile = Invoke-DownloadWithRetry $downloadUrl

$setupPath = Join-Path $env:TEMP "BizTalkBuildComponent"
if (-not (Test-Path -Path $setupPath)) {
    New-Item -Path $setupPath -ItemType Directory -Force | Out-Null
}
Expand-7ZipArchive -Path $zipFile -DestinationPath $setupPath

Write-Host "Installing BizTalk Project Build Component..."
Install-Binary `
    -LocalPath "$setupPath\Bootstrap.msi" `
    -ExtraInstallArgs ("/l*v", "$setupPath\bootstrap.log") `
    -ExpectedSignature $signatureThumbprint
Install-Binary `
    -LocalPath "$setupPath\BuildComponentSetup.msi" `
    -ExtraInstallArgs ("/l*v", "$setupPath\buildComponentSetup.log") `
    -ExpectedSignature $signatureThumbprint

Invoke-PesterTests -TestFile "BizTalk" -TestName "BizTalk Build Component Setup"
