<g:set var='securityConfig' value='${applicationContext.springSecurityService.securityConfig}'/>
<html>
<head>
    <meta name="layout" content="wekb"/>
    <title>we:kb : Login</title>
</head>

<body>
<div class="ui middle aligned center aligned grid">
    <div class="six wide column">
        <h1 class="ui header">
            <div class="content">
                Login
            </div>
        </h1>

        <semui:flashMessage data="${flash}"/>

        <g:form class="ui form" controller="login" action="authenticate" method="post" name="loginForm"
                elementId="loginForm" autocomplete="off">
            <div class="ui stacked segment">
                <div class="field">
                    <div class="ui left icon input">
                        <i class="user icon"></i>
                        <input type="text" id="username" placeholder="Username"
                               name="${securityConfig.apf.usernameParameter}">
                    </div>
                </div>

                <div class="field">
                    <div class="ui left icon input">
                        <i class="lock icon"></i>
                        <input type="password" id="password" placeholder="Password"
                               name="${securityConfig.apf.passwordParameter}">
                    </div>
                </div>

                <button class="ui fluid submit black button" type="submit">Login</button>
            </div>

        </g:form>

        <div class="ui message">
            <div class="ui relaxed list">
                <div class="item">
                    <g:link action="forgotPassword"><g:message
                        code="forgottenPassword.forgotPassword"/></g:link>
                </div>
                <div class="item">
                    <a href="#" onclick="$('#infoModal').modal('show');">Not yet registered for a we:kb: account?</a>
                </div>
            </div>
        </div>
    </div>
</div>

<semui:modal id="infoModal" title="Info" hideSubmitButton="true">
    Contact us at <a
        href="mailto:laser@hbz-nrw.de">laser@hbz-nrw.de</a> so that we can set up an account for you and provide you with your initial login information.
</semui:modal>

</body>
</html>
