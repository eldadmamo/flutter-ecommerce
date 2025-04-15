//import aws sdk

const {SESClient, SendEmailCommand} = require('@aws-sdk/client-ses');

// load the enviroment from the .env file
require('dotenv').config();

//initialize SES client using enviromental variables

const client = new SESClient({
    region: process.env.AWS_REGION,
    credentials:{
        accessKeyId: process.env.AWS_ACCESS_KEY_ID, 
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY, //aws secret key for secure access
    },
})

//Function to generate simple HTML content for welcome email

const generateWelcomeEmailHtml = () => {
    return `
    <html>
      <body>
         <h1>Welcome to ${process.env.APP_NAME}</h1>
      </body>
    </html>
    `
};

const sendWelcomeEmail = async(email) => {
    const params = {
        Source : process.env.EMAIL_FROM,
        ReplyToAddress : [process.env.EMAIL_TO], 

        Destination: {
            ToAddresses: [email],
        }, 

        Message:{
            Body: {
                Html:{
                    Charset: "UTF-8",
                    Data: generateWelcomeEmailHtml()
                }
            }, 

            Subject: {
                Charset: "UTF-8",
                Data: `Welcome to ${process.env.APP_NAME}` 
            }
        }
    };

    const command = new SendEmailCommand(params);

    try{
        const data = await client.send(command);
        return data;
    }catch(error){
        console.log("error sending emails")
        throw error;
    }
};

module.exports = sendWelcomeEmail;
