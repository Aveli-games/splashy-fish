const bucketName = process.env.GCLOUD_STORAGE_BUCKET;
const version = process.env.GAME_VERSION
const fileName = 'scores.json';

const filePath = `${version}/${fileName}`

// Imports the Google Cloud client library
const {Storage} = require('@google-cloud/storage');

// Creates a client
const storage = new Storage();

async function uploadFromMemory(contents) {
    await storage.bucket(bucketName).file(filePath).save(contents);

    console.log(
        `${filePath} with contents ${contents} uploaded to ${bucketName}.`
    );
}
async function downloadIntoMemory() {
    // Downloads the file into a buffer in memory.
    const contents = await storage.bucket(bucketName).file(filePath).download();

    console.log(
        `Contents of gs://${bucketName}/${filePath} are ${contents.toString()}.`
    );
    return contents
}

module.exports = {
    downloadIntoMemory,
    uploadFromMemory
}
