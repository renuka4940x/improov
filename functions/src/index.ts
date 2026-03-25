import * as functions from "firebase-functions/v1";
import { Resend } from "resend";

// Initialize Resend
const resend = new Resend(process.env.RESEND_API_KEY);

export const sendWelcomeEmail = functions.auth.user().onCreate(async (user) => {
  const email = user.email;
  const displayName = user.displayName || "Improover";

  if (!email) {
    console.log("User has no email address. Skipping welcome email.");
    return;
  }

  try {
    const response = await resend.emails.send({
      from: "Improov <hello@improov.in>",
      to: email,
      subject: "Welcome to Improov! 🚀",
      html: `
        <div style="font-family: sans-serif; color: #333; max-width: 600px; margin: 0 auto;">
          <h2>Welcome to the journey, ${displayName}!</h2>
          <p>We are thrilled to have you onboard.</p>
          <p>Improov was built to help you track your habits, hit your goals, and become the best version of yourself.</p>
          <p>If you have any feedback or just want to say hi, reply directly to this email.</p>
          <br/>
          <p>Stay consistent,</p>
          <p><strong>Ren & The Improov Team</strong></p>
        </div>
      `,
    });

    console.log("✅ Email sent successfully:", response);
  } catch (error) {
    console.error("❌ Failed to send welcome email:", error);
  }
});