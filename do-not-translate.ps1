function ConvertTo-LinuxLineEndings($path) {
    $oldBytes = [io.file]::ReadAllBytes($path)
    if (!$oldBytes.Length) {
        return;
    }
    [byte[]]$newBytes = @()
    [byte[]]::Resize([ref]$newBytes, $oldBytes.Length)
    $newLength = 0
    for ($i = 0; $i -lt $oldBytes.Length - 1; $i++) {
        if (($oldBytes[$i] -eq [byte][char]"`r") -and ($oldBytes[$i + 1] -eq [byte][char]"`n")) {
            continue;
        }
        $newBytes[$newLength++] = $oldBytes[$i]
    }
    $newBytes[$newLength++] = $oldBytes[$oldBytes.Length - 1]
    [byte[]]::Resize([ref]$newBytes, $newLength)
    [io.file]::WriteAllBytes($path, $newBytes)
}
function Get-IniContent ($filePath)
{
	$ini = @{}
	switch -regex -file $FilePath
	{
    	"(.+?)\s*=(.*)" # Key
    	{
        	$name,$value = $matches[1..2]
        	$ini[$name] = $value
    	}
	}
	return $ini
}
$ORIGINAL_INI = Get-IniContent "original/global.ini"
$TRANSLATED_INI = Get-IniContent "translated/global.ini"
$PATTERN_INI = Get-IniContent "do-not-translate-pattern.ini"

$PATTERN_INI.GetEnumerator() | ForEach-Object{
    if (!$_.key.StartsWith(";")) {
        $patternKeepOriginal = $_.value
        # no look if we need to keep the original text
        $message = "Searching keys in orginal file matching {0} in order to keep them as is..." -f $patternKeepOriginal
        Write-Output $message
        $count = 0
        $ORIGINAL_INI.GetEnumerator() | ForEach-Object{
            if ($_.key -cmatch $patternKeepOriginal) {
                $count = $count + 1
                $TRANSLATED_INI[$_.key] = $_.value
            }
        }
        $message = "Keeping {0} keys" -f $count
        Write-Output $message
    }
}
Write-Output "Now, copying inexisting translated key from original file..."
$count = 0
$ORIGINAL_INI.GetEnumerator() | ForEach-Object{
    if(!$TRANSLATED_INI.ContainsKey($_.key)) {
        $count = $count + 1
        $TRANSLATED_INI[$_.key] = $_.value
    }
}
$message = "Adding {0} keys" -f $count
Write-Output $message
Out-File -Encoding utf8 -FilePath "global.ini" 
#New-Item -Name global.ini -ItemType File -Force
Write-Output "writing result in ./global.ini, it will take some times..."
$PSDefaultParameterValues = @{ 'out-file:encoding' = 'utf8' }
$TRANSLATED_INI.GetEnumerator() | Sort-Object -Property key | ForEach-Object {
    $message = "{0}={1}" -f $_.key,$_.value
    $message >> "./global.ini"
}

