/* ============================================
   Office VPN System — JavaScript
   ============================================ */

document.addEventListener('DOMContentLoaded', function() {

    // ── Auto-dismiss alerts after 5 seconds ──
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function() {
                alert.remove();
            }, 300);
        }, 5000);
    });

    // ── Close alert buttons ──
    document.querySelectorAll('.close-alert').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var alert = this.closest('.alert');
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function() { alert.remove(); }, 300);
        });
    });

    // ── Sidebar toggle (mobile) ──
    var hamburger = document.querySelector('.hamburger');
    var sidebar = document.querySelector('.sidebar');
    if (hamburger && sidebar) {
        hamburger.addEventListener('click', function() {
            sidebar.classList.toggle('open');
        });
        // Close sidebar on clicking outside
        document.addEventListener('click', function(e) {
            if (sidebar.classList.contains('open') &&
                !sidebar.contains(e.target) &&
                !hamburger.contains(e.target)) {
                sidebar.classList.remove('open');
            }
        });
    }

    // ── Delete confirmations ──
    document.querySelectorAll('.btn-delete').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to delete this? This action cannot be undone.')) {
                e.preventDefault();
            }
        });
    });

    // ── Revoke confirmations ──
    document.querySelectorAll('.btn-revoke').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to revoke this access?')) {
                e.preventDefault();
            }
        });
    });

    // ── Form validation ──
    document.querySelectorAll('form[data-validate]').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            var isValid = true;
            var requiredInputs = form.querySelectorAll('[required]');
            requiredInputs.forEach(function(input) {
                if (!input.value.trim()) {
                    isValid = false;
                    input.style.borderColor = '#EF4444';
                    input.style.boxShadow = '0 0 0 3px #FEE2E2';
                } else {
                    input.style.borderColor = '';
                    input.style.boxShadow = '';
                }
            });
            if (!isValid) {
                e.preventDefault();
                alert('Please fill in all required fields.');
            }
        });
    });

    // ── Toggle add form panel ──
    var toggleFormBtn = document.querySelector('.btn-toggle-form');
    var formPanel = document.querySelector('.add-form-panel');
    if (toggleFormBtn && formPanel) {
        toggleFormBtn.addEventListener('click', function() {
            if (formPanel.style.display === 'none' || formPanel.style.display === '') {
                formPanel.style.display = 'block';
                formPanel.style.animation = 'slideDown 0.3s ease';
                toggleFormBtn.textContent = '✕ Cancel';
                toggleFormBtn.classList.remove('btn-primary');
                toggleFormBtn.classList.add('btn-outline');
            } else {
                formPanel.style.display = 'none';
                toggleFormBtn.textContent = '+ Add New';
                toggleFormBtn.classList.remove('btn-outline');
                toggleFormBtn.classList.add('btn-primary');
            }
        });
    }

    // ── Edit button — populate form fields ──
    document.querySelectorAll('.btn-edit').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var data = JSON.parse(this.getAttribute('data-item'));
            var form = document.querySelector('.edit-form') || document.querySelector('.add-form-panel form');
            if (!form) return;

            // Show the form panel
            if (formPanel) {
                formPanel.style.display = 'block';
            }

            // Populate fields
            for (var key in data) {
                var input = form.querySelector('[name="' + key + '"]');
                if (input) {
                    input.value = data[key];
                }
            }

            // Change action to update
            var actionInput = form.querySelector('[name="action"]');
            if (actionInput) {
                actionInput.value = 'update';
            }

            // Scroll to form
            formPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
    });

    // ── Table search/filter ──
    var tableSearch = document.querySelector('.table-search-input');
    if (tableSearch) {
        tableSearch.addEventListener('input', function() {
            var filter = this.value.toLowerCase();
            var table = document.querySelector('.data-table');
            if (!table) return;
            var rows = table.querySelectorAll('tbody tr');
            rows.forEach(function(row) {
                var text = row.textContent.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        });
    }

    // ── Animate stat cards on load ──
    document.querySelectorAll('.stat-card').forEach(function(card, index) {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        setTimeout(function() {
            card.style.transition = 'all 0.4s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 100 * (index + 1));
    });

    // ── Animate table rows on load ──
    document.querySelectorAll('.data-table tbody tr').forEach(function(row, index) {
        row.style.opacity = '0';
        setTimeout(function() {
            row.style.transition = 'opacity 0.3s ease';
            row.style.opacity = '1';
        }, 50 * (index + 1));
    });

});
