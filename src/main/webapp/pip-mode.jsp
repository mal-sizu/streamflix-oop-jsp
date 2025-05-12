<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Picture-in-Picture Mode - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pip-mode.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Picture-in-Picture Mode</h1>
            
            <div class="pip-container">
                <div class="pip-info">
                    <h2>Watch While You Browse</h2>
                    <p>Picture-in-Picture (PiP) mode allows you to continue watching your video in a small floating window while browsing other content on StreamFlix.</p>
                    
                    <div class="pip-steps">
                        <div class="pip-step">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <h3>Start Watching</h3>
                                <p>Begin playing any movie or TV show episode</p>
                            </div>
                        </div>
                        
                        <div class="pip-step">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <h3>Enable PiP Mode</h3>
                                <p>Click the PiP button in the player controls</p>
                            </div>
                        </div>
                        
                        <div class="pip-step">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <h3>Browse Freely</h3>
                                <p>Continue browsing while your video plays in a floating window</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="pip-demo">
                        <img src="${pageContext.request.contextPath}/images/pip-demo.jpg" alt="PiP Mode Demonstration">
                    </div>
                </div>
                
                <div class="pip-compatibility">
                    <h2>Device Compatibility</h2>
                    <p>Picture-in-Picture mode is available on the following browsers and devices:</p>
                    
                    <div class="compatibility-list">
                        <div class="compatibility-item">
                            <i class="fab fa-chrome"></i>
                            <span>Chrome (Desktop & Android)</span>
                        </div>
                        
                        <div class="compatibility-item">
                            <i class="fab fa-safari"></i>
                            <span>Safari (macOS & iOS)</span>
                        </div>
                        
                        <div class="compatibility-item">
                            <i class="fab fa-firefox"></i>
                            <span>Firefox (Desktop)</span>
                        </div>
                        
                        <div class="compatibility-item">
                            <i class="fab fa-edge"></i>
                            <span>Microsoft Edge</span>
                        </div>
                        
                        <div class="compatibility-item">
                            <i class="fab fa-opera"></i>
                            <span>Opera</span>
                        </div>
                    </div>
                </div>
                
                <div class="pip-tips">
                    <h2>Tips & Tricks</h2>
                    
                    <div class="tips-list">
                        <div class="tip-item">
                            <div class="tip-icon">
                                <i class="fas fa-arrows-alt"></i>
                            </div>
                            <div class="tip-content">
                                <h3>Resize the PiP Window</h3>
                                <p>Click and drag the corners of the PiP window to resize it to your preferred size.</p>
                            </div>
                        </div>
                        
                        <div class="tip-item">
                            <div class="tip-icon">
                                <i class="fas fa-mouse-pointer"></i>
                            </div>
                            <div class="tip-content">
                                <h3>Reposition the Window</h3>
                                <p>Click and drag the PiP window to move it anywhere on your screen.</p>
                            </div>
                        </div>
                        
                        <div class="tip-item">
                            <div class="tip-icon">
                                <i class="fas fa-keyboard"></i>
                            </div>
                            <div class="tip-content">
                                <h3>Keyboard Shortcuts</h3>
                                <p>Use the spacebar to play/pause and arrow keys to skip forward or backward.</p>
                            </div>
                        </div>
                        
                        <div class="tip-item">
                            <div class="tip-icon">
                                <i class="fas fa-expand"></i>
                            </div>
                            <div class="tip-content">
                                <h3>Return to Full Screen</h3>
                                <p>Double-click the PiP window to return to the full player view.</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="pip-try-now">
                    <h2>Try It Now</h2>
                    <p>Start watching any content and experience the convenience of Picture-in-Picture mode.</p>
                    <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">Browse Content</a>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>