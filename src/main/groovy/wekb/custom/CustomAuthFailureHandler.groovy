package wekb.custom

import grails.gorm.transactions.Transactional
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler
import wekb.auth.User

import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class CustomAuthFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Override
    @Transactional
    void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {

        if (exception instanceof BadCredentialsException) {
            try {
                String uname = request.getParameter('username')
                User user = User.findByUsername(uname)

                user.invalidLoginAttempts = (user.invalidLoginAttempts ?: 0 ) + 1
                if (user.invalidLoginAttempts >= 5) {
                    user.accountLocked = true
                }
                user.save()
            }
            catch(Exception e) {}
        }

        super.onAuthenticationFailure(request, response, exception)
    }
}