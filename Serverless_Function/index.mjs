import AWS from 'aws-sdk'; // AWS SDK for accessing Secrets Manager
import Mailgun from 'mailgun.js'; // Mailgun SDK
import formData from 'form-data'; // Mailgun SDK requires 'form-data'

// Initialize AWS Secrets Manager client
const secretsManager = new AWS.SecretsManager({ region: 'us-east-1' }); // Replace with your region

/**
 * Fetches Mailgun credentials from AWS Secrets Manager
 * @param {string} secretName - Name of the secret in Secrets Manager
 */

const SECRET_NAME = process.env.SECRET_NAME;

const getMailgunSecrets = async () => {
  try {
    const secretValue = await secretsManager
      .getSecretValue({ SecretId: SECRET_NAME })
      .promise();

    return JSON.parse(secretValue.SecretString); // Parse JSON secrets
  } catch (error) {
    console.error('Error fetching secrets from Secrets Manager:', error);
    throw new Error('Failed to retrieve Mailgun credentials');
  }
};

/**
 * Main Lambda handler for SNS trigger
 */
export const handler = async (event) => {
  try {
    // Parse SNS message
    const message = JSON.parse(event.Records[0].Sns.Message);
    const { email, verification_url, first_name, last_name } = message;

    // Fetch Mailgun credentials from Secrets Manager
    const secretName = 'mailgun-credentials'; // Replace with your secret name
    const { MAILGUN_API_KEY, MAILGUN_DOMAIN, MAILGUN_FROM_ADDRESS } = await getMailgunSecrets(secretName);

    // Send the verification email using Mailgun API
    await sendVerificationEmail(email, verification_url, first_name, last_name, {
      MAILGUN_API_KEY,
      MAILGUN_DOMAIN,
      MAILGUN_FROM_ADDRESS,
    });

    console.log('Lambda execution completed successfully.');
  } catch (error) {
    console.error('Error in Lambda execution:', error);
    throw error;
  }
};

/**
 * Sends a verification email via Mailgun
 */
const sendVerificationEmail = async (email, verificationLink, firstName, lastName, mailgunCredentials) => {
  const { MAILGUN_API_KEY, MAILGUN_DOMAIN, MAILGUN_FROM_ADDRESS } = mailgunCredentials;

  // Initialize Mailgun client
  const mg = new Mailgun(formData);
  const mailgunClient = mg.client({ username: 'api', key: MAILGUN_API_KEY });

  const emailParams = {
    from: MAILGUN_FROM_ADDRESS,
    to: email,
    subject: 'Welcome to WebApp! Please Verify Your Email',
    html: `
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; padding: 20px; }
          .container { max-width: 600px; margin: auto; text-align: center; }
          .btn { padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Hi ${firstName} ${lastName},</h1>
          <p>Welcome to WebApp! We're excited to have you on board.</p>
          <p>To complete your registration, please click on the below link to verify your email:</p>
          <a href="${verificationLink}">${verificationLink}</a>
          <p>If you did not sign up for this account, please ignore this email.</p>
          <p>Thank you,<br>The WebApp Team</p>
        </div>
      </body>
      </html>
    `,
  };

  try {
    // Send the email via Mailgun
    await mailgunClient.messages.create(MAILGUN_DOMAIN, emailParams);
    console.log(`Verification email sent to ${email}`);
  } catch (error) {
    console.error('Error sending email via Mailgun:', error);
    throw error;
  }
};
