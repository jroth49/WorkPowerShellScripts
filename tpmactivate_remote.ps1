$TPM = Get-WMIObject -Class "Win32_Tpm" -Namespace "ROOT\CIMV2\Security\MicrosoftTpm"
$TPM.SetPhysicalPresenceRequest(6)

#https://docs.microsoft.com/en-us/windows/win32/secprov/setphysicalpresencerequest-win32-tpm
