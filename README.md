# santa-dndump - A tool to listen for Santa's Distributed Notifications in a script

Subscribes to Santa's distributed notifications for a single block and dumps
data from associated user info to stdout as JSON.

Inspired by [dndump](https://github.com/nktzbkv/dndump).


# Building 

Clone or download, then run `make`

# Usage 

```bash
prompt$ ./santa-dndump
```
```json
{
  "file_path" : "\/usr\/bin\/osascript",
  "file_bundle_version" : "",
  "parent_name" : "zsh",
  "signing_chain" : [
    {
      "sha256" : "d84db96af8c2e60ac4c851a21ec460f6f84e0235beb17d24a78712b9b021ed57",
      "valid_until" : 1792863581,
      "org" : "Apple Inc.",
      "valid_from" : 1603996358,
      "ou" : "Apple Software",
      "cn" : "Software Signing"
    },
    {
      "sha256" : "5bdab1288fc16892fef50c658db54f1e2e19cf8f71cc55f77de2b95e051e2562",
      "valid_until" : 1792863581,
      "org" : "Apple Inc.",
      "valid_from" : 1319477981,
      "ou" : "Apple Certification Authority",
      "cn" : "Apple Code Signing Certification Authority"
    },
    {
      "sha256" : "b0b1730ecbc7ff4505142c49f1295e6eda6bcaed7e2c68c5be91b5a11001f024",
      "valid_until" : 2054670036,
      "org" : "Apple Inc.",
      "valid_from" : 1146001236,
      "ou" : "Apple Certification Authority",
      "cn" : "Apple Root CA"
    }
  ],
  "file_bundle_name" : "osascript",
  "executing_user" : "peterm",
  "ppid" : 31049,
  "file_bundle_id" : "com.apple.osascript",
  "file_sha256" : "2e6d005d3b29e3f61dc0bfa26e664e27a9d0bbea20d4182f96be902f21ea914b",
  "file_bundle_version_string" : "",
  "execution_time" : 1726358449.942713,
  "team_id" : "",
  "pid" : 31307
}
```

# Using JQ and Curl to Upload the Blocked Binary When Something is Blocked

:warning: This is a best effort technique and not 100% reliable. :warning:

```bash
#!/bin/sh
# Script to upload a file that was blocked by Santa using curl.

BLOCKED_FILEPATH=`./santa-dndump | jq '.file_path' | tr -d '"'`

curl -X POST -H "Content-Type: application/octet-stream" \
  --data-binary "@$BLOCKED_FILEPATH" https://example.com/upload
```
