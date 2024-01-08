const bucketName = process.env.GCLOUD_STORAGE_BUCKET;
const fileName = 'scores.json';


// Imports the Google Cloud client library
const {Storage} = require('@google-cloud/storage');

// Creates a client
const storage = new Storage();

async function uploadFromMemory(contents) {
    await storage.bucket(bucketName).file(fileName).save(contents);

    console.log(
        `${fileName} with contents ${contents} uploaded to ${bucketName}.`
    );
}
async function downloadIntoMemory() {
    // Downloads the file into a buffer in memory.
    const contents = await storage.bucket(bucketName).file(fileName).download();

    console.log(
        `Contents of gs://${bucketName}/${fileName} are ${contents.toString()}.`
    );
    return contents
}

module.exports = {
    downloadIntoMemory,
    uploadFromMemory
}
