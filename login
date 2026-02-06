<!DOCTYPE html>
<html>
<body>
    <h2>Login</h2>
    <div id="step1">
        <input type="email" id="email" placeholder="Email"><br><br>
        <input type="password" id="password" placeholder="Password"><br><br>
        <button onclick="login()">Login</button>
    </div>

    <div id="step2" style="display:none;">
        <h3>Enter OTP (Check Python Console for code)</h3>
        <input type="text" id="otp" placeholder="1234"><br><br>
        <button onclick="verify()">Verify</button>
    </div>

    <script>
        async function login() {
            let email = document.getElementById('email').value;
            let password = document.getElementById('password').value;
            
            let response = await fetch('/login-action', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({email: email, password: password})
            });
            let result = await response.json();
            
            if(result.status === 'success') {
                document.getElementById('step1').style.display = 'none';
                document.getElementById('step2').style.display = 'block';
            } else {
                alert('Wrong password');
            }
        }

        async function verify() {
            let email = document.getElementById('email').value;
            let otp = document.getElementById('otp').value;
            
            let response = await fetch('/verify-otp-action', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({email: email, otp: otp})
            });
            let result = await response.json();
            
            if(result.redirect) {
                window.location.href = result.redirect;
            } else {
                alert('Wrong OTP');
            }
        }
    </script>
</body>
</html>
