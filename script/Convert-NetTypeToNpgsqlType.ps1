# https://www.npgsql.org/doc/types/basic.html

Function Convert-NetTypeToNpgsqlType {
    [OutputType([string])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$TypeName
    )

    Begin {
        $map = @{
            "System.String"         = "Text"
            "System.Boolean"        = "Boolean"
            "System.Int32"          = "Integer"
            "System.Int64"          = "Bigint"
            "System.Double"         = "Double"
            "System.Guid"           = "Uuid"
            "System.DateTimeOffset" = "TimestampTz"
            "System.DateTime"       = "Timestamp"
        }
    }

    Process {
        return $map[$TypeName]
    }
}