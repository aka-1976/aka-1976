@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@echo off

SETLOCAL

rem Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS.
SET DEFAULT_JVM_OPTS="-Xmx64m"

SET DIR=%~dp0
IF "%DIR%" == "" SET DIR=%CD%
SET APP_BASE_NAME=%~n0
SET APP_HOME=%DIR%

rem Find java.exe
IF DEFINED JAVA_HOME GOTO findJavaFromJavaHome
SET JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
IF %ERRORLEVEL% EQ 0 GOTO execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the location of your Java installation.
echo.
GOTO fail

:findJavaFromJavaHome
SET JAVA_HOME=%JAVA_HOME:"=%
SET JAVA_EXE=%JAVA_HOME%\bin\java.exe
IF NOT EXIST "%JAVA_EXE%" GOTO failJavaHome
GOTO execute

:failJavaHome
echo.
echo ERROR: JAVA_HOME set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the location of your Java installation.
echo.
GOTO fail

:execute
rem Setup the command line
SET CMD_LINE_ARGS=
:setArgs
IF ""%1"" == "" GOTO doneSetArgs
SET CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
SHIFT
GOTO setArgs
:doneSetArgs

rem Check for START_DIR
IF NOT "%START_DIR%" == "" GOTO executeInStartDir

SET SCRIPT_PATH="%APP_HOME%gradle\wrapper\gradle-wrapper.jar"
IF NOT EXIST %SCRIPT_PATH% (
    echo.
    echo ERROR: Gradle wrapper JAR not found. Have you run 'gradle wrapper'?
    echo.
    GOTO fail
)

"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%APP_HOME%gradle\wrapper\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %CMD_LINE_ARGS%
IF %ERRORLEVEL% NEQ 0 GOTO fail

GOTO end

:executeInStartDir
rem Execute in START_DIR
PUSHD %START_DIR%
SET SCRIPT_PATH="%APP_HOME%gradle\wrapper\gradle-wrapper.jar"
IF NOT EXIST %SCRIPT_PATH% (
    echo.
    echo ERROR: Gradle wrapper JAR not found. Have you run 'gradle wrapper'?
    echo.
    POPD
    GOTO fail
)

"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%APP_HOME%gradle\wrapper\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %CMD_LINE_ARGS%
IF %ERRORLEVEL% NEQ 0 (
    POPD
    GOTO fail
)
POPD
GOTO end

:fail
ENDLOCAL
EXIT /b %ERRORLEVEL%

:end
ENDLOCAL
EXIT /b 0
