
| Dev	                                                                                                                                                                                                                                                                                                                      | Main 	 |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| ![Build Status](https://codebuild.ap-northeast-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoieGhlck4vWkxDR3ExU3VmSEVyYlBUek9MVDFMY0Zqc3VaVWd5d1crUEFSZ1pYc1VnemNsWVY2cGpJbUdGQ1JXeGlEQ2pYaGRsOC9GZTczNnlhNUIzQlVJPSIsIml2UGFyYW1ldGVyU3BlYyI6InRDRDdKdHJUNzZ5TjIzVW4iLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=dev) |![Build Status](https://codebuild.ap-northeast-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoieGhlck4vWkxDR3ExU3VmSEVyYlBUek9MVDFMY0Zqc3VaVWd5d1crUEFSZ1pYc1VnemNsWVY2cGpJbUdGQ1JXeGlEQ2pYaGRsOC9GZTczNnlhNUIzQlVJPSIsIml2UGFyYW1ldGVyU3BlYyI6InRDRDdKdHJUNzZ5TjIzVW4iLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)|

This readme is about how to setup and create FluentBit DaemonSet for your cluster.
Note: this readme isn't had part about spinning up of AWS OpenSearch, let's assume that you already have one.

Do the following steps:
1. Check that your cluster has OIDC provider.
2. Create IAM policy with ability to use AWS OpenSearch:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "es:ESHttp*"
            ],
            "Resource": "arn:aws:es:_region_:account_number:domain/your_domain",
            "Effect": "Allow"
        }
    ]
}
```
3. Assign policy to the role that will be used by fluentBit Service account
4. Create Service account change `eks.amazonaws.com/role-arn: your_role_arn` to your role arn
```
kubectl create -f service_account.yaml
```
5. Create cluster role
```
kubectl create -f cluster-role.yaml
```
6. Create Cluster role binding
```
kubectl create -f cluster-role.yaml
```
7. Create ConfigMap for you DaemonSet.
```
kubectl create -f cluster-role.yaml
```
Take a note on a few things:
* input-kubernetes.conf:
  * Path - you can put as many paths to parse as you want separated by comma
  * Exclude_Path - you can put as many paths to ignore as you want separated by comma
* output-elasticsearch.conf:
  * Host - your Opensearch Host
  * Logstash_Format - if enabled FluentBit will put logs in separate indexes for each date.
  * Logstash_Prefix_Key - prefix for each index - could be label from k8s, e.x. kubernetes['pod_name']

8. Finally, create DaemonSet
```
kubectl create -f daemonset.yaml
```
9. Check pods state and logs of any pod, you will see `403` permissions errors
10. Setup Permissions on the ES side:
* go to Security -> roles
* create role with:
  * CRUD on Cluster permissions
  * CRUD on any index - needed to create new indexes for each day
  * assign `your_role` from the step 3 as **internal user**
11. Check that there is no more`403` on DaemonSet side
12. Check that new indexes are created in Index Managment -> Indeces
13. To make them searchable in Kibana go to Stack Managment -> Index Patterns -> Create new pattern to match your index

TODO: Create multiline parser for lotus logs check [TODO_MULTILINE_PARSER.txt](TODO_MULTILINE_PARSER.txt)
