(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

Import-Module PsGet
Install-Module Pester