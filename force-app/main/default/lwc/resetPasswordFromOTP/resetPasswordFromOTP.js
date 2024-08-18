import { LightningElement, api, track } from 'lwc';
import getUserByToken from '@salesforce/apex/PasswordResetController.getUserByToken';
import resetUserPassword from '@salesforce/apex/PasswordResetController.resetUserPassword';

export default class PasswordReset extends LightningElement {
    @api token;
    @track user;
    @track newPassword;
    @track confirmPassword;
    @track errorMessage;
    @track successMessage; // Added to track success message

    connectedCallback() {
        this.loadUser();
    }

    async loadUser() {
        try {
            this.user = await getUserByToken({ token: this.token });
        } catch (error) {
            this.errorMessage = error.body.message;
        }
    }

    handlePasswordChange(event) {
        this.newPassword = event.target.value;
    }

    handleConfirmPasswordChange(event) {
        this.confirmPassword = event.target.value;
    }

    async resetPassword() {
        if (this.newPassword !== this.confirmPassword) {
            this.errorMessage = 'Passwords do not match.';
            return;
        }

        try {
            await resetUserPassword({ userId: this.user.Id, newPassword: this.newPassword });
            this.successMessage = 'Password reset successfully.'; // Set success message
            this.errorMessage = null; // Clear error message
        } catch (error) {
            this.errorMessage = error.body.message;
            this.successMessage = null; // Clear success message
        }
    }
}
