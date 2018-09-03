
file=$1
export API_HOST=$(jq -r '.url' $file)
export NETWORK_ID=$(jq -r '.network_id'  $file)
export key=$(jq -r '.key'  $file)
export secret=$(jq -r '.secret'  $file)
export AUTH=$(echo -n $key:$secret | base64 -w 0)

curl -X GET "$API_HOST/api/v1/networks/$NETWORK_ID/connection_profile" -H  "accept: application/json" -H  "authorization: Basic $AUTH" > ConnPrfl.json


export cc_version=$(echo $INST_RESP | jq -r '.chaincodes[0].version')
export new_cc_version=$(jq -r '.version' cc-deploy-spec_resolved.json )
export ccid=$(jq -r '.ccID' cc-deploy-spec_resolved.json)
export ccPath=$(jq -r '.goPath' cc-deploy-spec_resolved.json)/src
export goRoot=$(jq -r '.ccSrcRootPath' cc-deploy-spec_resolved.json)
