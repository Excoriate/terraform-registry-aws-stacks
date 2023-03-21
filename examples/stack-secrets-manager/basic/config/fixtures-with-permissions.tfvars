aws_region = "us-east-1"
is_enabled = true

stack = "test"

secret_name          = "test/stack/terraform5"
replicate_in_regions = ["us-west-2", "sa-east-1", "eu-central-1"]
permissions          = ["GetSecretValue", "PutSecretValue", "DeleteSecretValue", "DescribeSecret", "ListSecrets", "ListSecretVersionIds", "DescribeSecretVersion", "RestoreSecret", "RotateSecret", "UpdateSecret", "UpdateSecretVersionStage", "TagResource"]
