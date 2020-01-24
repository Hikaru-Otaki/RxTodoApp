import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
const serviceAccount = require("../instagramapp-ca8e2-firebase-adminsdk-czaz6-dc5deb8627.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    // storageBucketはローカルで実行するときのみ必要。
    // Functions上ではFunctions側で設定される
    storageBucket: "gs://instagramapp-ca8e2.appspot.com"
  });

exports.onProfileImgaeUpdate = functions.firestore.document("users/{userID}").onUpdate(async(change, context) => {
    const afterData = change.after.data() as any;
    const beforeData = change.before.data() as any;
    if (afterData.profileImage === beforeData.profileImage) {
        console.log("一緒です")
    } else {
        await deleteFile(beforeData.profileImage)
        console.log("変化がありました。")
    }
    console.log(afterData.profileImage);
    console.log(beforeData.profileImage);
});

function deleteFile(uploadedPath: any) {
    console.log('Yes!');
    const bucket = admin.storage().bucket();
    return bucket.file(uploadedPath).delete();
}


