Function Connect-PgSql {
    Param(
        [Parameter(Mandatory)][PSCredential]$Credential,
        [Parameter()][string]$Server = "localhost",
        [Parameter()][int]$Port = 5432,
        [Parameter()][string]$Database = "postgres",
        [Parameter()][string]$Query,
        [Parameter()][Switch]$AsHashTable,
        [Parameter()][HashTable]$Parameters
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

    $connection.Open()

    return $connection
}