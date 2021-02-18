import '../core/app_config.dart';

/// Allows easy modification of all strings inside the app
/// In addition to that, this makes it much easier to provide multiple
/// translations later on if needed
class Strings {
  static const appName = 'Wadi Green';

  /// Common
  static const viewAll = 'VIEW ALL';
  static const retry = 'Retry';
  static const unauthorizedAccess = 'Unauthorized access';
  static const karma = 'Karma';
  static const plants = 'Plants';
  static const role = 'Role';
  static const yes = 'Yes';
  static const cancel = 'Cancel';
  static const submit = 'Submit';
  static const save = 'Save';
  static const send = 'Send';
  static const title = 'Title';
  static const notifications = 'Notifications';

  /// Drawer
  static const dashboard = 'Dashboard';
  static const home = 'Home';
  static const activities = 'Activities';
  static const friends = 'Friends';
  static const personalPlant = 'Personal plant';
  static const myActivities = 'My activities';
  static const inviteFriends = 'Invite Friends';
  static const settings = 'Settings';
  static const profileSettings = 'Profile settings';
  static const logout = 'Log out';
  static const planters = 'Planters';
  static const signUp = 'Sign Up';
  static const login = 'Log In';

  /// Landing
  static const mostLikedActivities = 'Most liked activities';
  static const allActivities = 'All activities';
  static const mostActivePlanters = 'Most active planters';
  static const howItWorks = 'How it works';
  static const startGrowingYourPlants = 'Start growing your plants now!';
  static const becomeAPlanter = 'BECOME A PLANTER NOW!';

  /// Report bug
  static const reportABug = 'Report a bug';
  static const report = 'Report';
  static const explainTheBug = 'Explain the bug';
  static const bugDetails = 'Bug details';
  static const bugReported = 'Bug reported successfully';
  static const thankYouForReporting = 'Thank you for helping us improve this application!';

  /// Search
  static const search = 'Search';
  static const searchError = 'Something went wrong. Please retry your search';
  static const activitiesList = 'Activities list';
  static const relatedHashtags = 'Related hashtags';
  static const activityCategories = 'Activity categories';
  static const popularHashtags = 'Popular hashtags';
  static const findAnActivity = 'Find an activity';

  /// Activity
  static const fullDescription = 'Full description';
  static const stepsToComplete = 'Steps to complete';
  static const benefits = 'Benefits';
  static const ease = 'Ease';
  static const likes = 'Likes';
  static const follows = 'Follows';
  static const externalLinks = 'External links';
  static const visit = 'Visit';
  static const cannotLaunchLink = 'The app was unable to launch this link';
  static const markStepCompleted = 'Mark step as completed';
  static const markStepCompletedConfirmation =
      'Are you sure you want to complete this step?';
  static const comment = 'Comment';
  static const stepCommentHint = 'Comments about this step';
  static const noComments = 'No comments';

  /// Dashboard
  static const friendsActivities = 'Friends activities';
  static const myCalendar = 'My Calendar';

  /// Authentication
  static const socialMediaLogin = 'Social media log in';
  static const socialMediaSignUp = 'Social media sign up';
  static const continueWithGoogle = 'Continue with Google';
  static const continueWithFacebook = 'Continue with Facebook';
  static const credentials = 'Credentials';
  static const email = 'Email';
  static const password = 'Password';
  static const confirmPassword = 'Confirm password';
  static const passwordConfirmation = 'Password confirmation';
  static const keepMeLoggedIn = 'Keep me logged in';
  static const forgotPassword = 'Forgot password';
  static const noAccount = "Don't have an account?";
  static const passwordHint = 'Your password must be at least 6 characters';
  static const iAgreeTo = 'I agree to';
  static const termsAndConditions = 'Terms and Conditions.';
  static const alreadyAMember = 'Already a member?';
  static const pleaseAgreeToTerms =
      'Please agree to the terms and conditions first';
  static const signUpSuccessful = 'Sign up successful';
  static const signUpCheckEmail =
      'Please check your email for the link to verify your registration';

  /// Member screen
  static const message = 'Message';
  static const viewPlants = 'View plants';

  /// Invitation form
  static const inviteAFriend = 'Invite a friend';
  static const friendName = 'Friend name';
  static const friendEmail = 'Friend email';
  static const pleaseWriteMessage = 'Please write a message';
  static const invitationSent = 'Invitation successfully sent';
  static const thankYouForInviting =
      'Thank you for helping this community grow!';

  /// Profile Screen
  static const basicInformation = 'Basic Information';
  static const fullName = 'Full name';
  static const profilePhoto = 'Profile photo';
  static const aboutYourself = 'Tell us about yourself';
  static const favoriteActivities = 'Favorite activities';
  static const chooseActivity = 'Choose activity';
  static const accountSettings = 'Account settings';
  static const changePassword = 'Change password';
  static const closeAccount = 'Close account';
  static const oldPassword = 'Old password';
  static const newPassword = 'New Password';
  static const profileUpdated = 'Profile updated successfully';
  static const closeAccountConfirmation =
      'Are you sure you want to close your account?';
  static const passwordChanged = 'Your password has been successfully updated';

  /// Messages
  static const noMessagesYet = 'No messages yet';

  /// API
  static const genericError = 'Something went wrong';
  static const serverError500 =
      'Something broke in the backend, get in touch with ${AppConfig.supportEmail}';
}
