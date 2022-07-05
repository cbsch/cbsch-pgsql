# Simple Powershell wrapper for Npgsql

```powershell
Install-Module cbsch-pgsql -Scope CurrentUser
$credential = Get-Credential
$connection = Connect-PgSql -Credential $credential

Invoke-PgSql -Connection $connection -Query @"
CREATE TABLE test(
    id int,
    guid uuid,
    date timestamp with time zone,
    smallint integer,
    bigint bigint,
    double double precision
)
"@

Invoke-PgSql -Connection $connection -Query @"
INSERT INTO test(id, guid, date, smallint, bigint, double)
VALUES(@id, @guid, @date, @smallint, @bigint, @double)
"@ -Parameters @{
    "@id" = 1
    "@guid" = [Guid]::NewGuid()
    "@date" = Get-Date
    "@smallint" = 42
    "@bigint" = [Int64]::MaxValue
    "@double" = 0.23
}

Invoke-PgSql -Connection $connection -Query "SELECT * FROM test"
```