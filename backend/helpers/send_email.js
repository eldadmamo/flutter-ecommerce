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

const generateOTPEmailHtml = (otp) => {
    return `
    <html>
      <body>
         <h1>Welcome to ${process.env.APP_NAME}</h1>
         <p>Your One-Time password (OTP) for email verification is : </p>
         <p>${otp}</p>
         <p>Please enter this OTP to verify your email address. This code is valid for the next 10 minutes</p>
         <p>if you did not request this please ignore this email or contact our support team immediately </p>
         
      </body>
    </html>
    `
};

const sendOTPEmail = async(email, otp) => {
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
                    Data: generateOTPEmailHtml(otp)
                }
            }, 

            Subject: {
                Charset: "UTF-8",
                Data: `Destamerch Email Verification` 
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

module.exports = sendOTPEmail;
