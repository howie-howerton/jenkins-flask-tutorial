import "hash"

rule matchme_test
{
    meta:
        severity = "critical"
        description = "Found match-me.txt test"

    condition:
        hash.sha256(0, filesize) == "0f1ab220eb1d12bdd92a34389cc0f9581a21967ee278ed7269874a56c0158932"
}
