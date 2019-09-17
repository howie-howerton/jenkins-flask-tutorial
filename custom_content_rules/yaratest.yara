import "hash"

rule README_test
{
    meta:
        severity = "critical"
        description = "Found README test"

    condition:
        hash.sha256(0, filesize) == "75754a126de18faefd5f71541f5bdcceae0ca4d819ee2fbf11c435b0773ab1da"
}
