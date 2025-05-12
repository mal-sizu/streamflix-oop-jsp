/**
 * admin.js - JavaScript functionality for admin panel
 */

$(document).ready(function() {
    // Toggle sidebar on mobile
    $('.toggle-sidebar').on('click', function() {
        $('.admin-sidebar').toggleClass('show');
    });
    
    // Close sidebar when clicking outside on mobile
    $(document).on('click', function(e) {
        if ($(window).width() <= 768) {
            if (!$(e.target).closest('.admin-sidebar').length && !$(e.target).closest('.toggle-sidebar').length) {
                $('.admin-sidebar').removeClass('show');
            }
        }
    });
    
    // Dropdown menus
    $('.dropdown-toggle').on('click', function(e) {
        e.preventDefault();
        $(this).next('.dropdown-menu').toggleClass('show');
    });
    
    // Close dropdowns when clicking outside
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.dropdown').length) {
            $('.dropdown-menu').removeClass('show');
        }
    });
    
    // Confirm delete actions
    $('.confirm-delete').on('click', function(e) {
        if (!confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
            e.preventDefault();
        }
    });
    
    // Form validation
    $('.admin-form').on('submit', function(e) {
        let isValid = true;
        
        // Check required fields
        $(this).find('input[required], select[required], textarea[required]').each(function() {
            if ($(this).val().trim() === '') {
                isValid = false;
                $(this).addClass('is-invalid');
                
                // Add error message if not exists
                if ($(this).next('.form-error').length === 0) {
                    $(this).after('<div class="form-error">This field is required.</div>');
                }
            } else {
                $(this).removeClass('is-invalid');
                $(this).next('.form-error').remove();
            }
        });
        
        // Check email fields
        $(this).find('input[type="email"]').each(function() {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if ($(this).val() !== '' && !emailRegex.test($(this).val())) {
                isValid = false;
                $(this).addClass('is-invalid');
                
                // Add error message if not exists
                if ($(this).next('.form-error').length === 0) {
                    $(this).after('<div class="form-error">Please enter a valid email address.</div>');
                }
            }
        });
        
        // Check password fields
        const passwordField = $(this).find('input[name="password"]');
        const confirmPasswordField = $(this).find('input[name="confirmPassword"]');
        
        if (passwordField.length > 0 && confirmPasswordField.length > 0) {
            if (passwordField.val() !== confirmPasswordField.val()) {
                isValid = false;
                confirmPasswordField.addClass('is-invalid');
                
                // Add error message if not exists
                if (confirmPasswordField.next('.form-error').length === 0) {
                    confirmPasswordField.after('<div class="form-error">Passwords do not match.</div>');
                }
            } else {
                confirmPasswordField.removeClass('is-invalid');
                confirmPasswordField.next('.form-error').remove();
            }
            
            // Check password strength
            if (passwordField.val() !== '' && passwordField.val().length < 8) {
                isValid = false;
                passwordField.addClass('is-invalid');
                
                // Add error message if not exists
                if (passwordField.next('.form-error').length === 0) {
                    passwordField.after('<div class="form-error">Password must be at least 8 characters long.</div>');
                }
            }
        }
        
        if (!isValid) {
            e.preventDefault();
            
            // Scroll to first error
            const firstError = $('.is-invalid').first();
            $('html, body').animate({
                scrollTop: firstError.offset().top - 100
            }, 500);
        }
    });
    
    // Clear validation errors on input
    $(document).on('input', '.admin-form input, .admin-form select, .admin-form textarea', function() {
        $(this).removeClass('is-invalid');
        $(this).next('.form-error').remove();
    });
    
    // File input preview
    $('.custom-file-input').on('change', function() {
        const fileName = $(this).val().split('\\').pop();
        $(this).next('.custom-file-label').html(fileName);
        
        // Image preview
        if (this.files && this.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                $('#imagePreview').attr('src', e.target.result).show();
            }
            
            reader.readAsDataURL(this.files[0]);
        }
    });
    
    // Form wizard navigation
    $('.wizard-next').on('click', function() {
        const currentStep = $(this).closest('.wizard-step-content');
        const nextStep = currentStep.next('.wizard-step-content');
        
        // Validate current step
        let isValid = true;
        
        currentStep.find('input[required], select[required], textarea[required]').each(function() {
            if ($(this).val().trim() === '') {
                isValid = false;
                $(this).addClass('is-invalid');
                
                // Add error message if not exists
                if ($(this).next('.form-error').length === 0) {
                    $(this).after('<div class="form-error">This field is required.</div>');
                }
            } else {
                $(this).removeClass('is-invalid');
                $(this).next('.form-error').remove();
            }
        });
        
        if (isValid && nextStep.length > 0) {
            // Hide current step
            currentStep.hide();
            
            // Show next step
            nextStep.show();
            
            // Update active step
            $('.wizard-step').removeClass('active');
            $('.wizard-step').eq(nextStep.index()).addClass('active');
            
            // Mark previous steps as completed
            for (let i = 0; i < nextStep.index(); i++) {
                $('.wizard-step').eq(i).addClass('completed');
            }
            
            // Scroll to top of form
            $('html, body').animate({
                scrollTop: $('.form-wizard').offset().top - 50
            }, 500);
        }
    });
    
    $('.wizard-prev').on('click', function() {
        const currentStep = $(this).closest('.wizard-step-content');
        const prevStep = currentStep.prev('.wizard-step-content');
        
        if (prevStep.length > 0) {
            // Hide current step
            currentStep.hide();
            
            // Show previous step
            prevStep.show();
            
            // Update active step
            $('.wizard-step').removeClass('active');
            $('.wizard-step').eq(prevStep.index()).addClass('active');
            
            // Scroll to top of form
            $('html, body').animate({
                scrollTop: $('.form-wizard').offset().top - 50
            }, 500);
        }
    });
    
    // AJAX search in admin
    $('#adminSearch').on('keyup', function() {
        const query = $(this).val();
        const searchType = $('#searchType').val();
        
        if (query.length >= 2) {
            $.ajax({
                url: '/admin/search',
                data: {
                    query: query,
                    type: searchType
                },
                dataType: 'json',
                success: function(data) {
                    let resultsHtml = '';
                    
                    if (data.length > 0) {
                        resultsHtml += '<div class="search-results-list">';
                        
                        for (let i = 0; i < data.length; i++) {
                            resultsHtml += `
                                <div class="search-result-item">
                                    <a href="${data[i].url}">
                                        <div class="result-title">${data[i].title}</div>
                                        <div class="result-info">${data[i].info}</div>
                                    </a>
                                </div>
                            `;
                        }
                        
                        resultsHtml += '</div>';
                    } else {
                        resultsHtml = '<div class="no-results">No results found</div>';
                    }
                    
                    $('#searchResults').html(resultsHtml).show();
                }
            });
        } else {
            $('#searchResults').hide();
        }
    });
    
    // Sortable tables
    $('.sortable').on('click', 'th.sortable-column', function() {
        const table = $(this).closest('table');
        const index = $(this).index();
        const rows = table.find('tbody tr').toArray();
        const dir = $(this).hasClass('asc') ? -1 : 1;
        
        // Update sort direction
        table.find('th.sortable-column').removeClass('asc desc');
        $(this).addClass(dir === 1 ? 'asc' : 'desc');
        
        // Sort rows
        rows.sort(function(a, b) {
            const aValue = $(a).children('td').eq(index).text().trim();
            const bValue = $(b).children('td').eq(index).text().trim();
            
            // Check if values are numbers
            if (!isNaN(aValue) && !isNaN(bValue)) {
                return dir * (parseFloat(aValue) - parseFloat(bValue));
            }
            
            // Sort as strings
            return dir * aValue.localeCompare(bValue);
        });
        
        // Reorder rows
        $.each(rows, function(index, row) {
            table.children('tbody').append(row);
        });
    });
    
    // Initialize any charts
    if (typeof Chart !== 'undefined') {
        initializeCharts();
    }
    
    // Initialize episode reordering
    $('#episodeList').sortable({
        handle: '.drag-handle',
        update: function(event, ui) {
            // Update episode numbers
            $('#episodeList .episode-item').each(function(index) {
                $(this).find('.episode-number').text(index + 1);
                $(this).find('input[name="episodeNumber[]"]').val(index + 1);
            });
        }
    });
    
    // Add episode button
    $('#addEpisode').on('click', function() {
        const episodeCount = $('#episodeList .episode-item').length;
        const seasonSelect = $('#seasonSelect').val();
        
        const newEpisode = `
            <div class="episode-item">
                <div class="drag-handle">
                    <i class="fas fa-grip-lines"></i>
                </div>
                <div class="episode-number">${episodeCount + 1}</div>
                <div class="episode-form">
                    <input type="hidden" name="episodeId[]" value="">
                    <input type="hidden" name="season[]" value="${seasonSelect}">
                    <input type="hidden" name="episodeNumber[]" value="${episodeCount + 1}">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Episode Title</label>
                                <input type="text" name="episodeTitle[]" class="form-control" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Media URL</label>
                                <input type="text" name="episodeMediaUrl[]" class="form-control" required>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="episode-actions">
                    <button type="button" class="btn-icon danger remove-episode">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `;
        
        $('#episodeList').append(newEpisode);
    });
    
    // Remove episode
    $(document).on('click', '.remove-episode', function() {
        $(this).closest('.episode-item').remove();
        
        // Update episode numbers
        $('#episodeList .episode-item').each(function(index) {
            $(this).find('.episode-number').text(index + 1);
            $(this).find('input[name="episodeNumber[]"]').val(index + 1);
        });
    });
    
    // Season change
    $('#seasonSelect').on('change', function() {
        const season = $(this).val();
        
        // Show episodes for selected season
        $('.episode-item').hide();
        $(`.episode-item[data-season="${season}"]`).show();
    });
});

/**
 * Initialize dashboard charts
 */
function initializeCharts() {
    // User registration chart
    const userCtx = document.getElementById('userRegistrationChart');
    
    if (userCtx) {
        new Chart(userCtx, {
            type: 'line',
            data: {
                labels: userChartData.labels,
                datasets: [{
                    label: 'New Users',
                    data: userChartData.data,
                    backgroundColor: 'rgba(78, 115, 223, 0.05)',
                    borderColor: 'rgba(78, 115, 223, 1)',
                    pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                    pointBorderColor: 'rgba(78, 115, 223, 1)',
                    pointHoverBackgroundColor: 'rgba(78, 115, 223, 1)',
                    pointHoverBorderColor: 'rgba(78, 115, 223, 1)',
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        precision: 0
                    }
                }
            }
        });
    }
    
    // Content by type chart
    const contentCtx = document.getElementById('contentTypeChart');
    
    if (contentCtx) {
        new Chart(contentCtx, {
            type: 'doughnut',
            data: {
                labels: contentChartData.labels,
                datasets: [{
                    data: contentChartData.data,
                    backgroundColor: [
                        'rgba(78, 115, 223, 0.8)',
                        'rgba(28, 200, 138, 0.8)',
                        'rgba(246, 194, 62, 0.8)',
                        'rgba(231, 74, 59, 0.8)'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
    
    // Subscription plan chart
    const subscriptionCtx = document.getElementById('subscriptionPlanChart');
    
    if (subscriptionCtx) {
        new Chart(subscriptionCtx, {
            type: 'bar',
            data: {
                labels: subscriptionChartData.labels,
                datasets: [{
                    label: 'Subscribers',
                    data: subscriptionChartData.data,
                    backgroundColor: 'rgba(28, 200, 138, 0.8)',
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        precision: 0
                    }
                }
            }
        });
    }
}
