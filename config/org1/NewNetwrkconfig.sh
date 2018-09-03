
file=$1
#export file=Org1_api_profile.json
export API_HOST=$(jq -r '.url' $file)
export NETWORK_ID=$(jq -r '.network_id'  $file)
export key=$(jq -r '.key'  $file)
export secret=$(jq -r '.secret'  $file)
export AUTH=$(echo -n $key:$secret | base64 -w 0)


echo "Getting Connection Profile"
echo "URL: $API_HOST/api/v1/networks/$NETWORK_ID/connection_profile"
echo "Authentication: Basic $AUTH"

#curl -X GET "$API_HOST/api/v1/networks/$NETWORK_ID/connection_profile" -H  "accept: application/json" -H  "authorization: Basic $AUTH" > ConnPrfl.json

echo "Getting the Instantiated chaincodes"
echo "URL:  $API_HOST/api/v1/networks/$NETWORK_ID/channels/defaultchannel/chaincode/instantiated"


INST_RESP=$(curl -X POST \
  "$API_HOST/api/v1/networks/$NETWORK_ID/channels/defaultchannel/chaincode/instantiated" \
  -H  "Content-Type: application/json" \
  -H "accept: application/json" \
  -H  "authorization: Basic $AUTH" \
    -d "{  \"peer_names\": [    \"org1-peer1\"  ],  \"SKIP_CACHE\": true}" \
  --connect-timeout 60 || true)


  echo ******
  echo "Chaincode Instantiated Response"
  echo $INST_RESP

  echo *******

echo "Install chaincode"
echo "URL: $API_HOST/api/v1/networks/$NETWORK_ID/chaincode/install"
echo "Authentication: Basic $AUTH"

#export cc_version=$(echo $INST_RESP | jq -r '.chaincodes[0].version')
export new_cc_version=$(jq -r '.version' cc-deploy-spec_resolved.json )
export ccid=$(jq -r '.ccID' cc-deploy-spec_resolved.json)
export ccPath=$(jq -r '.goPath' cc-deploy-spec_resolved.json)/src
export goRoot=$(jq -r '.ccSrcRootPath' cc-deploy-spec_resolved.json)

echo "New chaincode_version: $new_cc_version"
echo "Chaincode ID: $ccid"
echo "Chaincode Path : $ccPath"
echo "GoRoot: $goRoot"

echo "Moving to chaincode folder"
cd $ccPath
echo $(pwd)
echo "Zipping project folder to upload"
zip $goRoot.zip $goRoot

echo " Install URL:$API_HOST/api/v1/networks/$NETWORK_ID/chaincode/install "

#INSTALL_RESP=$(curl -X POST "$API_HOST/api/v1/networks/$NETWORK_ID/chaincode/install" \
#-H  "accept: application/json" \
#-H  "authorization: Basic $AUTH" \
#-H  "Content-Type: multipart/form-data" \
#-F "files=$goRoot.zip;type=application/x-zip-compressed" -F "chaincode_id=$ccid" -F "chaincode_version=$new_cc_version" \
#-F "chaincode_type=golang")


echo ******
echo "Install Response"
echo $INSTALL_RESP
