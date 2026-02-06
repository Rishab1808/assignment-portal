<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>SecureSubmit – Login</title>

<style>
:root {
    --primary: #2563eb;
    --primary-hover: #1d4ed8;
    --bg-color: #f3f4f6;
    --card-bg: #ffffff;
    --text-dark: #1f2937;
    --text-light: #6b7280;
    --danger: #ef4444;
    --border: #e5e7eb;
}

* {
    box-sizing: border-box;
    font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

body {
    margin: 0;
    min-height: 100vh;
    background-color: var(--bg-color);
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Card */
.card {
    width: 100%;
    max-width: 380px;
    background: var(--card-bg);
    padding: 2.5rem;
    border-radius: 14px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.08);
    border: 1px solid var(--border);
    animation: fadeIn 0.4s ease;
}

/* Headings */
.portal-title {
    text-align: center;
    color: var(--primary);
    font-weight: 600;
    margin-bottom: 0.25rem;
}

.subtitle {
    text-align: center;
    color: var(--text-dark);
    font-size: 1.05rem;
    font-weight: 600;
    margin-bottom: 1.5rem;
}

/* Inputs */
input {
    width: 100%;
    padding: 0.75rem;
    margin-bottom: 1rem;
    border-radius: 6px;
    border: 1px solid var(--border);
    font-size: 0.95rem;
}

input:focus {
    outline: none;
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

/* Button */
button {
    width: 100%;
    padding: 0.75rem;
    background-color: var(--primary);
    border: none;
    border-radius: 6px;
    color: #fff;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s ease;
}

button:hover {
    background-color: var(--primary-hover);
}

/* Errors */
.error {
    color: var(--danger);
    text-align: center;
    font-size: 0.85rem;
    margin-top: 0.5rem;
}

/* Utility */
.hidden {
    display: none;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(6px); }
    to   { opacity: 1; transform: translateY(0); }
}

body.otp-mode {
    background-color: #e5edff;
}
</style>
</head>

<body>

<div class="card">

    <!-- STEP 1 -->
    <div id="step1">
        <h2 class="portal-title">🔐 SecureSubmit</h2>
        <div class="subtitle">Login</div>

        <input type="email" id="email" placeholder="Email address" required>
        <input type="password" id="password" placeholder="Password" required>

        <button onclick="login()">Sign In</button>
        <div class="error" id="loginError"></div>
    </div>

    <!-- STEP 2 -->
    <div id="step2" class="hidden">
        <h2 class="portal-title">OTP Verification</h2>
        <div class="subtitle">Enter the code sent to your email</div>

        <input type="text" id="otp" placeholder="6-digit OTP" maxlength="6">
        <button onclick="verify()">Verify & Continue</button>
        <div class="error" id="otpError"></div>
    </div>

</div>

<script>
async function login() {
    const email = emailInput().value.trim();
    const password = passwordInput().value;
    loginError().textContent = "";

    if (!email || !password) {
        loginError().textContent = "Please fill in all fields.";
        return;
    }

    try {
        const res = await fetch('/login-action', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ email, password })
        });

        if (!res.ok) throw new Error();
        const result = await res.json();

        if (result.status === "otp_required") {
            showOTP();
        } else {
            loginError().textContent = "Invalid login credentials.";
        }
    } catch {
        loginError().textContent = "Network error. Try again.";
    }
}

async function verify() {
    const otp = otpInput().value.trim();
    otpError().textContent = "";

    if (!otp) {
        otpError().textContent = "Enter the OTP code.";
        return;
    }

    try {
        const res = await fetch('/verify-otp-action', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ otp })
        });

        if (!res.ok) throw new Error();
        const result = await res.json();

        if (result.success) {
            window.location.href = result.redirect;
        } else {
            otpError().textContent = "Invalid or expired OTP.";
        }
    } catch {
        otpError().textContent = "Network error. Try again.";
    }
}

function showOTP() {
    document.getElementById("step1").classList.add("hidden");
    document.getElementById("step2").classList.remove("hidden");
    document.body.classList.add("otp-mode");
    emailInput().disabled = true;
}

/* Helpers */
const emailInput = () => document.getElementById("email");
const passwordInput = () => document.getElementById("password");
const otpInput = () => document.getElementById("otp");
const loginError = () => document.getElementById("loginError");
const otpError = () => document.getElementById("otpError");
</script>

</body>
</html>

