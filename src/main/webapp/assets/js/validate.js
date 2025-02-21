// Regular expression constants
const REGEX = {
    USERNAME: /^[a-zA-Z0-9_]{4,20}$/,        // 4-20 chars, alphanumeric + underscore
    NAME: /^[A-Za-z]+$/,                     // Letters only
    EMAIL: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,     // Standard email format
    MOBILE: /^[0-9]{10}$/,                   // Exactly 10 digits
    PASSWORD_COMPLEXITY: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}/ // 8+ chars, 1 uppercase, 1 lowercase, 1 number
};

// Validation messages
const MESSAGES = {
    REQUIRED: "Please fill out this field",
    USERNAME: "Username must be 4-20 characters and can only contain letters, numbers, and underscores",
    FIRST_NAME: "First Name should contain only letters",
    LAST_NAME: "Last Name should contain only letters",
    EMAIL: "Please enter a valid email address",
    MOBILE: "Mobile number must be exactly 10 digits",
    PASSWORD: "Password must contain 8+ characters, at least one uppercase letter, one lowercase letter, and one number",
    PASSWORD_MATCH: "Passwords do not match",
    GENDER: "Please select a valid gender"
};

// Check if field is empty
function isEmpty(value) {
    return value.trim() === '';
}

// Helper function to show error message
function showError(inputElement, message) {
    const errorElement = inputElement.nextElementSibling;
    if (errorElement && errorElement.classList.contains('error-message')) {
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }
}

// Helper function to clear error
function clearError(inputElement) {
    const errorElement = inputElement.nextElementSibling;
    if (errorElement && errorElement.classList.contains('error-message')) {
        errorElement.textContent = '';
        errorElement.style.display = 'none';
    }
}

// Individual field validations
function validateUsername(usernameInput) {
    const value = usernameInput.value;
    if (isEmpty(value)) {
        showError(usernameInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.USERNAME.test(value)) {
        showError(usernameInput, MESSAGES.USERNAME);
        return false;
    }
    clearError(usernameInput);
    return true;
}

function validateName(nameInput, fieldName) {
    const value = nameInput.value;
    if (isEmpty(value)) {
        showError(nameInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.NAME.test(value)) {
        showError(nameInput, MESSAGES[fieldName]);
        return false;
    }
    clearError(nameInput);
    return true;
}

function validateEmail(emailInput) {
    const value = emailInput.value;
    if (isEmpty(value)) {
        showError(emailInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.EMAIL.test(value)) {
        showError(emailInput, MESSAGES.EMAIL);
        return false;
    }
    clearError(emailInput);
    return true;
}

function validateMobile(mobileInput) {
    const value = mobileInput.value;
    if (isEmpty(value)) {
        showError(mobileInput, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.MOBILE.test(value)) {
        showError(mobileInput, MESSAGES.MOBILE);
        return false;
    }
    clearError(mobileInput);
    return true;
}

function validatePassword(passwordInput) {
    const value = passwordInput.value;
    if (isEmpty(value)) {
        showError(passwordInput.parentElement, MESSAGES.REQUIRED);
        return false;
    }
    if (!REGEX.PASSWORD_COMPLEXITY.test(value)) {
        showError(passwordInput.parentElement, MESSAGES.PASSWORD);
        return false;
    }
    clearError(passwordInput.parentElement);
    return true;
}

function validateConfirmPassword(passwordInput, confirmPasswordInput) {
    const value = confirmPasswordInput.value;
    const passwordValue = passwordInput.value;
    if (isEmpty(value)) {
        showError(confirmPasswordInput.parentElement, MESSAGES.REQUIRED);
        return false;
    }
    if (value !== passwordValue) {
        showError(confirmPasswordInput.parentElement, MESSAGES.PASSWORD_MATCH);
        return false;
    }
    clearError(confirmPasswordInput.parentElement);
    return true;
}

function validateGender(genderSelect) {
    const value = genderSelect.value;
    if (value !== "true" && value !== "false") {
        showError(genderSelect, MESSAGES.GENDER);
        return false;
    }
    clearError(genderSelect);
    return true;
}

// Main validation function
function validateForm() {
    const fields = {
        username: document.querySelector('input[name="username"]'),
        firstName: document.querySelector('input[name="firstName"]'),
        lastName: document.querySelector('input[name="lastName"]'),
        email: document.querySelector('input[name="email"]'),
        mobile: document.querySelector('input[name="mobile"]'),
        password: document.querySelector('input[name="password"]'),
        confirmPassword: document.querySelector('input[name="confirmPassword"]'),
        gender: document.querySelector('select[name="gender"]')
    };

    // Validate each field
    const isValid = [
        validateUsername(fields.username),
        validateName(fields.firstName, 'FIRST_NAME'),
        validateName(fields.lastName, 'LAST_NAME'),
        validateEmail(fields.email),
        validateMobile(fields.mobile),
        validatePassword(fields.password),
        validateConfirmPassword(fields.password, fields.confirmPassword),
        validateGender(fields.gender)
    ].every(result => result);

    return isValid;
}


