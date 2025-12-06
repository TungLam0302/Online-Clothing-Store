/**
 * Customer Layout Scripts
 * Enhances the functionality of sidebar and other customer-facing layout elements
 */

document.addEventListener('DOMContentLoaded', function() {
    // Mobile sidebar toggle functionality
    const mobileToggleBtn = document.getElementById('mobile-sidebar-toggle');
    const mobileSidebar = document.querySelector('.mobile-sidebar');
    const mobileSidebarClose = document.getElementById('mobile-sidebar-close');
    const mobileSidebarBackdrop = document.getElementById('mobile-sidebar-backdrop');
    
    if (mobileToggleBtn) {
        mobileToggleBtn.addEventListener('click', function() {
            mobileSidebar.classList.add('show');
            mobileSidebarBackdrop.style.display = 'block';
            document.body.style.overflow = 'hidden';
        });
    }
    
    if (mobileSidebarClose) {
        mobileSidebarClose.addEventListener('click', function() {
            mobileSidebar.classList.remove('show');
            mobileSidebarBackdrop.style.display = 'none';
            document.body.style.overflow = '';
        });
    }
    
    if (mobileSidebarBackdrop) {
        mobileSidebarBackdrop.addEventListener('click', function() {
            mobileSidebar.classList.remove('show');
            mobileSidebarBackdrop.style.display = 'none';
            document.body.style.overflow = '';
        });
    }
    
    // Initialize sidebar category accordions
    const categoryLinks = document.querySelectorAll('.parent-category-link');
    
    // Check if URL has category parameter to auto-expand the relevant parent category
    const urlParams = new URLSearchParams(window.location.search);
    const categoryParam = urlParams.get('category');
    const searchParam = urlParams.get('search');
    
    if (categoryParam) {
        // Find the subcategory and its parent
        const activeSubcategory = document.querySelector(`.subcategory-link[href$="category=${categoryParam}"]`);
        
        if (activeSubcategory) {
            // Mark subcategory as active
            activeSubcategory.classList.add('active');
            
            // Expand parent category
            const parentCollapseElement = activeSubcategory.closest('.collapse');
            if (parentCollapseElement) {
                const bsCollapse = new bootstrap.Collapse(parentCollapseElement, {
                    toggle: false
                });
                bsCollapse.show();
                
                // Update parent category chevron icon
                const parentLink = document.querySelector(`[href="#${parentCollapseElement.id}"]`);
                if (parentLink) {
                    const icon = parentLink.querySelector('i');
                    icon.classList.remove('fa-chevron-down');
                    icon.classList.add('fa-chevron-up');
                }
            }
        }
    }
    
    // Populate search inputs if there's a search parameter
    if (searchParam) {
        const searchInputs = document.querySelectorAll('input[name="search"]');
        searchInputs.forEach(input => {
            input.value = searchParam;
        });
    }
    
    // Toggle chevron icon on category expand/collapse
    categoryLinks.forEach(link => {
        link.addEventListener('click', function() {
            const icon = this.querySelector('i');
            if (icon.classList.contains('fa-chevron-down')) {
                icon.classList.remove('fa-chevron-down');
                icon.classList.add('fa-chevron-up');
            } else {
                icon.classList.remove('fa-chevron-up');
                icon.classList.add('fa-chevron-down');
            }
        });
    });
    
    // Brand filter checkbox auto-submit
    const brandCheckboxes = document.querySelectorAll('.brands-list input[type="checkbox"]');
    const minPriceInput = document.querySelector('input[name="minPrice"]');
    const maxPriceInput = document.querySelector('input[name="maxPrice"]');
    
    // Form validation for price filters
    if (minPriceInput && maxPriceInput) {
        minPriceInput.addEventListener('change', validatePriceRange);
        maxPriceInput.addEventListener('change', validatePriceRange);
    }
    
    function validatePriceRange() {
        const min = parseFloat(minPriceInput.value) || 0;
        const max = parseFloat(maxPriceInput.value) || Infinity;
        
        if (min > max && max > 0) {
            alert('Minimum price cannot be greater than maximum price');
            minPriceInput.value = '';
            return false;
        }
        
        return true;
    }
    
    // Handle mobile sidebar toggle
    const sidebarToggleBtn = document.getElementById('mobile-sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');
    
    if (sidebarToggleBtn && sidebar) {
        // Create backdrop element
        const backdrop = document.createElement('div');
        backdrop.classList.add('sidebar-backdrop');
        document.body.appendChild(backdrop);
        
        // Toggle sidebar function
        function toggleSidebar() {
            sidebar.classList.toggle('active');
            document.body.classList.toggle('sidebar-open');
            backdrop.classList.toggle('show');
        }
        
        // Event listeners
        sidebarToggleBtn.addEventListener('click', toggleSidebar);
        backdrop.addEventListener('click', toggleSidebar);
    }
    
    // Handle filter badge close buttons
    const filterCloseBtns = document.querySelectorAll('.badge-close');
    
    filterCloseBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = this.getAttribute('href');
        });
    });
});

// Add sticky header functionality on scroll
window.addEventListener('scroll', function() {
    const header = document.querySelector('.main-header');
    if (window.scrollY > 100) {
        header.classList.add('sticky');
    } else {
        header.classList.remove('sticky');
    }
});
