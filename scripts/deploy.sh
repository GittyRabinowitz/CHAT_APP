
# # without cloud
# if [ $# -eq 2 ]
# then
# requestedVersion=$1
# requestedCommitHash=$2

#     docker build -t  my-chat-app:$requestedVersion .

#     git tag $requestedVersion $requestedCommitHash
#     git push origin $requestedVersion
    
# else
#     echo "Not valid arguments"
# fi


# working with cloud
if [ $# -eq 2 ]
then
    requestedVersion=$1
    requestedCommitHash=$2

    # If the commit hash does not exist, tell the user and exit the script.
    if ! git rev-parse --verify "$requestedCommitHash" &>/dev/null; then
        echo "The commit hash $requestedCommitHash does not exist."
        exit 1
    fi




    image="my-chat-app"
    image_name="${image}:${requestedVersion}"

    # If the image exists, ask the user if they want to rebuild it.
    if docker inspect "$image_name" &>/dev/null; then
        echo "The image my-chat-app:$requestedVersion already exists."
        echo "Do you want to rebuild it? (y/n)"
        read -r REBUILD_IMAGE

        # If the user chooses to rebuild the image, delete the existing one.
        if [ "$REBUILD_IMAGE" = "y" ]; then
            docker rmi my-chat-app:$requestedVersion
            # Build the image.
            docker build -t my-chat-app:$requestedVersion .
        fi
    else 
        docker build -t my-chat-app:$requestedVersion .

    fi

    # Ask the user if they want to tag and push to git.
    echo "Do you want to tag and push the new version to git? (y/n)"
    read -r TAG_AND_PUSH


    # Tag and push the new version to git.
    # (This is now optional.)
    if [ "$TAG_AND_PUSH" = "y" ]; then
        git tag $requestedVersion $requestedCommitHash
        git push origin $requestedVersion
    fi


    # Ask the user if they want to push the image to the Artifact Registry repository.
    echo "Do you want to push the image to the Artifact Registry repository? (y/n)"
    read -r PUSH_IMAGE
    
    # If the user chooses to push the image, do so using service account impersonation.
    if [ "$PUSH_IMAGE" = "y" ]; then

        appname="chat-app"
        # Push the Docker image to Artifact Registry (optional)
        echo "Pushing Docker image to artifactregistry"
        gcloud config set auth/impersonate_service_account artifact-admin-sa@grunitech-mid-project.iam.gserviceaccount.com  
        gcloud auth configure-docker me-west1-docker.pkg.dev
        artifact_registry_image=me-west1-docker.pkg.dev/grunitech-mid-project/gittyrabinowitz-chat-app-images/${appname}:${requestedVersion}
        docker tag ${image_name} ${artifact_registry_image} 
        docker push ${artifact_registry_image}
        gcloud config set auth/impersonate_service_account gitty-instance-SA@grunitech-mid-project.iam.gserviceaccount.com  

    fi





else
    echo "Not valid arguments"
fi