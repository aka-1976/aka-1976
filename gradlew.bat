@REM
@REM Copyright 2010 the original author or authors.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@REM
@REM      https://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM

@if "%DEBUG%" == "" @set DEBUG=0

@if "%OS%" == "Windows_NT" @setlocal

@rem Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m"

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_EXE="%JAVA_HOME%\bin\java.exe"
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto execute
echo.
echo The JAVA_HOME environment variable is defined but points to an invalid Java installation.
echo.
echo Please revise the JAVA_HOME definition in your environment.
goto fail

:execute
@rem Setup Gradle properties
set DIR=%~dp0
set APP_BASE_NAME=%~n0
set APP_HOME=%DIR%

@rem Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
if not defined DEFAULT_JVM_OPTS set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m"

@rem Set to 0 to disable daemon, 1 to enable
set ORG_GRADLE_DAEMON_ENABLED=true

@rem Set to 0 to disable parallel execution, 1 to enable
set ORG_GRADLE_PARALLEL=false

@rem Set to 0 to disable configuration cache, 1 to enable
set ORG_GRADLE_CONFIGURATION_CACHE=false

@rem Set to 0 to disable file watching, 1 to enable
set ORG_GRADLE_FILE_WATCHING=false

@rem Set to 0 to disable build cache, 1 to enable
set ORG_GRADLE_BUILD_CACHE=false

@rem Set to 0 to disable console animations, 1 to enable
set ORG_GRADLE_CONSOLE_ANIMATIONS=true

@rem Set to 0 to disable color output, 1 to enable
set ORG_GRADLE_COLOR_OUTPUT=true

@rem Set to 0 to disable progress logging, 1 to enable
set ORG_GRADLE_PROGRESS_LOGGING=true

@rem Set to 0 to disable warnings, 1 to enable
set ORG_GRADLE_WARNINGS=all

@rem Set to 0 to disable stacktraces, 1 to enable
set ORG_GRADLE_STACKTRACES=full

@rem Set to 0 to disable verbose logging, 1 to enable
set ORG_GRADLE_VERBOSE=false

@rem Set to 0 to disable debug logging, 1 to enable
set ORG_GRADLE_DEBUG=false

@rem Set to 0 to disable info logging, 1 to enable
set ORG_GRADLE_INFO=false

@rem Set to 0 to disable quiet logging, 1 to enable
set ORG_GRADLE_QUIET=false

@rem Set to 0 to disable refresh dependencies, 1 to enable
set ORG_GRADLE_REFRESH_DEPENDENCIES=false

@rem Set to 0 to disable offline mode, 1 to enable
set ORG_GRADLE_OFFLINE=false

@rem Set to 0 to disable continuous build, 1 to enable
set ORG_GRADLE_CONTINUOUS_BUILD=false

@rem Set to 0 to disable scan, 1 to enable
set ORG_GRADLE_SCAN=false

@rem Set to 0 to disable profile, 1 to enable
set ORG_GRADLE_PROFILE=false

@rem Set to 0 to disable dry run, 1 to enable
set ORG_GRADLE_DRY_RUN=false

@rem Set to 0 to disable no-rebuild, 1 to enable
set ORG_GRADLE_NO_REBUILD=false

@rem Execute Gradle Wrapper
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.daemon.enabled=%ORG_GRADLE_DAEMON_ENABLED%" "-Dorg.gradle.parallel=%ORG_GRADLE_PARALLEL%" "-Dorg.gradle.configuration-cache=%ORG_GRADLE_CONFIGURATION_CACHE%" "-Dorg.gradle.file-watching=%ORG_GRADLE_FILE_WATCHING%" "-Dorg.gradle.build-cache=%ORG_GRADLE_BUILD_CACHE%" "-Dorg.gradle.console.animations=%ORG_GRADLE_CONSOLE_ANIMATIONS%" "-Dorg.gradle.color.output=%ORG_GRADLE_COLOR_OUTPUT%" "-Dorg.gradle.progress.logging=%ORG_GRADLE_PROGRESS_LOGGING%" "-Dorg.gradle.warnings=%ORG_GRADLE_WARNINGS%" "-Dorg.gradle.stacktraces=%ORG_GRADLE_STACKTRACES%" "-Dorg.gradle.verbose=%ORG_GRADLE_VERBOSE%" "-Dorg.gradle.debug=%ORG_GRADLE_DEBUG%" "-Dorg.gradle.info=%ORG_GRADLE_INFO%" "-Dorg.gradle.quiet=%ORG_GRADLE_QUIET%" "-Dorg.gradle.refresh-dependencies=%ORG_GRADLE_REFRESH_DEPENDENCIES%" "-Dorg.gradle.offline=%ORG_GRADLE_OFFLINE%" "-Dorg.gradle.continuous-build=%ORG_GRADLE_CONTINUOUS_BUILD%" "-Dorg.gradle.scan=%ORG_GRADLE_SCAN%" "-Dorg.gradle.profile=%ORG_GRADLE_PROFILE%" "-Dorg.gradle.dry-run=%ORG_GRADLE_DRY_RUN%" "-Dorg.gradle.no-rebuild=%ORG_GRADLE_NO_REBUILD%" "-Dorg.gradle.no-daemon=%ORG_GRADLE_NO_DAEMON%" "-Dorg.gradle.no-parallel=%ORG_GRADLE_NO_PARALLEL%" "-Dorg.gradle.no-configuration-cache=%ORG_GRADLE_NO_CONFIGURATION_CACHE%" "-Dorg.gradle.no-file-watching=%ORG_GRADLE_NO_FILE_WATCHING%" "-Dorg.gradle.no-build-cache=%ORG_GRADLE_NO_BUILD_CACHE%" "-Dorg.gradle.no-console=%ORG_GRADLE_NO_CONSOLE%" "-Dorg.gradle.no-color=%ORG_GRADLE_NO_COLOR%" "-Dorg.gradle.no-progress=%ORG_GRADLE_NO_PROGRESS%" "-Dorg.gradle.no-warnings=%ORG_GRADLE_NO_WARNINGS%" "-Dorg.gradle.no-stacktraces=%ORG_GRADLE_NO_STACKTRACES%" "-Dorg.gradle.no-verbose=%ORG_GRADLE_NO_VERBOSE%" "-Dorg.gradle.no-debug=%ORG_GRADLE_NO_DEBUG%" "-Dorg.gradle.no-info=%ORG_GRADLE_NO_INFO%" "-Dorg.gradle.no-quiet=%ORG_GRADLE_NO_QUIET%" "-Dorg.gradle.no-refresh-dependencies=%ORG_GRADLE_NO_REFRESH_DEPENDENCIES%" "-Dorg.gradle.no-offline=%ORG_GRADLE_NO_OFFLINE%" "-Dorg.gradle.no-continuous=%ORG_GRADLE_NO_CONTINUOUS%" "-Dorg.gradle.no-scan=%ORG_GRADLE_NO_SCAN%" "-Dorg.gradle.no-profile=%ORG_GRADLE_NO_PROFILE%" "-Dorg.gradle.no-dry-run=%ORG_GRADLE_NO_DRY_RUN%" "-Dorg.gradle.no-rebuild=%ORG_GRADLE_NO_REBUILD%" -classpath "%APP_HOME%gradle\wrapper\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %*
IF %ERRORLEVEL% NEQ 0 GOTO fail
:end
@if "%OS%" == "Windows_NT" @endlocal
exit /b %ERRORLEVEL%