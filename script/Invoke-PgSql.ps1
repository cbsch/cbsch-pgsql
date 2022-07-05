Function Invoke-PgSql {
    Param(
        [Parameter(Mandatory)][PSCredential]$Credential,
        [Parameter()][string]$Server = "localhost",
        [Parameter()][int]$Port = 5432,
        [Parameter()][string]$Database = "postgres",
        [Parameter()][string]$Query,
        [Parameter()][Switch]$AsHashTable
    )

    $factory = [Npgsql.NpgsqlFactory]::Instance
    $b = $factory.CreateConnectionStringBuilder()
    $b.UserName = $Credential.UserName
    $b.Password = $Credential.GetNetworkCredential().Password
    $b.Database = $Database
    $b.Port = $Port
    $b.Host = $Server

    $connection = $factory.CreateConnection()
    $connection.ConnectionString = $b.ToString()

    try {
        $connection.Open()
        $command = $factory.CreateCommand()
        $command.CommandText = $Query
        $command.Connection = $connection

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
        if ($connection) { $connection.Close() }
    }
}