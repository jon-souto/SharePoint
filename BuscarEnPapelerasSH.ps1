# Se tiene que ejecutar en PowerShell 7 o superior
# Instalar el módulo "PnP.PowerShell" si no está instalado (Install-Module -Name PnP.PowerShell)

# Configurar variable
$SiteURL = Read-Host "Introduce la URL del sitio"
$FileName = Read-Host "Introduce el nombre a buscar (admite caracteres comodín *ejemplo*)"

# Conectar a PnP.Online
Connect-PnPOnline -Url $SiteURL -Interactive

# Buscar elementos en la papelera de primer nivel
$itemsFirstStage = Get-PnPRecycleBinItem -FirstStage | Where-Object { $_.Title -like $FileName }

if ($itemsFirstStage.Count -gt 0) {
    Write-Host "Se encontraron los siguientes elementos en la papelera de primer nivel:"
    for ($i = 0; $i -lt $itemsFirstStage.Count; $i++) {
        $item = $itemsFirstStage[$i]
        Write-Host "$($i + 1). $($item.Title) [$($item.ItemType)]"
    }

    $itemsToRecover = @()
    $input = Read-Host "Para recuperar elementos de la papelera de primer nivel, ingresa los números separados por comas (por ejemplo, 1, 2, 3). Deja en blanco si no deseas recuperar ninguno"

    if ($input -ne "") {
        $selectedIndices = $input.Split(',') | ForEach-Object { [int]$_ }
        $itemsToRecover = $selectedIndices | ForEach-Object {
            if ($_ -ge 1 -and $_ -le $itemsFirstStage.Count) {
                $itemsFirstStage[$_ - 1]
            }
        }
    }

    if ($itemsToRecover.Count -gt 0) {
        $itemsToRecover | ForEach-Object {
            Write-Host "Recuperando elemento: $($_.Title)"
            Restore-PnPRecycleBinItem -Identity $_ -Force
        }
    } else {
        Write-Host "No se seleccionaron elementos para recuperar de la papelera de primer nivel."
    }
} else {
    Write-Host "No se encontraron elementos en la papelera de primer nivel."
}

# Buscar elementos en la papelera de segundo nivel
$itemsSecondStage = Get-PnPRecycleBinItem -SecondStage | Where-Object { $_.Title -like $FileName }

if ($itemsSecondStage.Count -gt 0) {
    Write-Host "Se encontraron los siguientes elementos en la papelera de segundo nivel"
    for ($i = 0; $i -lt $itemsSecondStage.Count; $i++) {
        $item = $itemsSecondStage[$i]
        Write-Host "$($i + 1). $($item.Title) [$($item.ItemType)]"
    }

    $itemsToRecover = @()
    $input = Read-Host "Para recuperar elementos de la papelera de segundo nivel, ingresa los números separados por comas (por ejemplo, 1, 2, 3). Deja en blanco si no deseas recuperar ninguno"

    if ($input -ne "") {
        $selectedIndices = $input.Split(',') | ForEach-Object { [int]$_ }
        $itemsToRecover = $selectedIndices | ForEach-Object {
            if ($_ -ge 1 -and $_ -le $itemsSecondStage.Count) {
                $itemsSecondStage[$_ - 1]
            }
        }
    }

    if ($itemsToRecover.Count -gt 0) {
        $itemsToRecover | ForEach-Object {
            Write-Host "Recuperando elemento: $($_.Title)"
            Restore-PnPRecycleBinItem -Identity $_ -Force
        }
    } else {
        Write-Host "No se seleccionaron elementos para recuperar de la papelera de segundo nivel."
    }
} else {
    Write-Host "No se encontraron elementos en la papelera de segundo nivel."
}
