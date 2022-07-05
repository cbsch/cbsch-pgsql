Function Invoke-PgSql {
    Param(
        [Parameter(ParameterSetName="Connection")][Npgsql.NpgsqlConnection]$Connection,
        [Parameter(ParameterSetName="Default", Mandatory)][PSCredential]$Credential,
        [Parameter(ParameterSetName="Default")][string]$Server = "localhost",
        [Parameter(ParameterSetName="Default")][int]$Port = 5432,
        [Parameter(ParameterSetName="Default")][string]$Database = "postgres",
        [Parameter()][string]$Query,
        [Parameter()][Switch]$AsHashTable,
        [Parameter()][HashTable]$Parameters
    )

    $factory = [Npgsql.NpgsqlFactory]::Instance

    if (!$connection) {
        $b = $factory.CreateConnectionStringBuilder()
        $b.UserName = $Credential.UserName
        $b.Password = $Credential.GetNetworkCredential().Password
        $b.Database = $Database
        $b.Port = $Port
        $b.Host = $Server

        $connection = $factory.CreateConnection()
        $connection.ConnectionString = $b.ToString()
        $connectionOwned = $true
    } else {
        $connectionOwned = $false
    }

    try {
        if ($connection.State -ne "Open") {
            $connection.Open()
        }

        $command = $factory.CreateCommand()
        $command.CommandText = $Query
        $command.Connection = $connection

        if ($Parameters) {
            foreach ($parameter in $Parameters.GetEnumerator()) {
                $command.Parameters.Add(
                    $parameter.Key,
                    (Convert-NetTypeToNpgsqlType $parameter.Value.PSObject.TypeNames[0])
                ) | Out-Null
                $command.Parameters[$parameter.Key].Value = $parameter.Value
            }
        }

        $adapter = $factory.CreateDataAdapter()
        $adapter.SelectCommand = $command
        $dataTable = [System.Data.DataTable]::new()
        $adapter.Fill($dataTable) | Out-Null

        $dataTable | % {
            $dataRow = $_

            $result = [ordered]@{}

            $dataRow.PSObject.Properties `
            | ? Name -notin Name, Table, RowState, RowError, HasErrors, ItemArray `
            | % {
                if ($_.Value.PSObject.TypeNames[0] -eq "System.DBNull") {
                    $value = $null
                } else {
                    $value = $_.Value
                }
                $result[$_.Name] = $value
            }

            if ($AsHashTable) {
                $result | Write-Output
            } else {
                [PSCustomObject]$result | Write-Output
            }
        }
    } finally {
        if ($reader) { $reader.Close() }
        if ($connection -and $connectionOwned) { $connection.Close() }
    }
}