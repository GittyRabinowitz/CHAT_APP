
if [ $# -eq 2 ]
then
requestedVersion=$1
requestedCommitHash=$2

    docker build -t mycoolimg:$requestedVersion .

    git tag $requestedVersion $requestedCommitHash
    git push origin $requestedVersion
    
else
    echo "Not valid arguments"
fi

#test