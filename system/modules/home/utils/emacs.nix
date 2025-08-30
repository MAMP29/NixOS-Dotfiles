{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk; # Versión más reciente
    extraPackages = epkgs: with epkgs; [
      # Sistema base de notas
      org
      org-roam
      org-journal
      org-roam-ui
      deft
      
      # Mejoras visuales
      org-modern
      org-appear
      olivetti
      
      # Búsqueda y navegación
      helm
      helm-org-rifle
      consult
      consult-org-roam
      
      # Manejo de PDFs
      pdf-tools
      org-noter
      org-pdftools
      
      # Sincronización y backup
      magit
      
      # Utilidades
      which-key
      use-package
      diminish
      doom-themes
      dashboard
    ];
    extraConfig = ''
      (setq inhibit-startup-message t)
      (setq make-backup-files nil)
      (setq auto-save-default nil)

      ;; Use-package para mejor organización
      (require 'use-package)
      (setq use-package-always-ensure t)

      ;; =====================================================
      ;; CONFIGURACIÓN DE ORG-MODE
      ;; =====================================================

      (use-package org
        :config
        ;; Directorio principal de notas
        (setq org-directory "~/notas/")
        
        ;; Archivos principales
        (setq org-default-notes-file "~/notas/inbox.org")
        (setq org-agenda-files '("~/notas/"))
        
        ;; Captura rápida de notas
        (setq org-capture-templates
              '(("t" "Tarea" entry (file+headline "~/notas/tareas.org" "Tareas")
                "* TODO %?\n  %U\n  %a\n  %i")
                ("n" "Nota" entry (file "~/notas/inbox.org")
                "* %?\n%U\n")
                ("j" "Diario" entry (file+datetree "~/notas/diario.org")
                "* %?\n%U\n")))
        
        ;; Atajos de teclado
        (global-set-key (kbd "C-c l") 'org-store-link)
        (global-set-key (kbd "C-c a") 'org-agenda)
        (global-set-key (kbd "C-c c") 'org-capture))

      ;; =====================================================
      ;; ORG-ROAM: Tu segundo cerebro
      ;; =====================================================

      (use-package org-roam
        :config
        ;; Directorio de tu base de conocimiento
        (setq org-roam-directory "~/notas/roam/")
        
        ;; Base de datos
        (setq org-roam-db-location "~/notas/org-roam.db")
        
        ;; Plantillas para nuevas notas
        (setq org-roam-capture-templates
              '(("d" "default" plain
                "%?"
                :target (file+head "%<%Y%m%d%H%M%S>-''${slug}.org" "#+title: ''${title}\n#+date: %U\n\n")
                :unnarrowed t)
                ("c" "concepto" plain
                "* Definición\n%?\n\n* Enlaces relacionados\n\n* Referencias\n"
                :target (file+head "%<%Y%m%d%H%M%S>-''${slug}.org" "#+title: ''${title}\n#+filetags: :concepto:\n#+date: %U\n\n")
                :unnarrowed t)
                ("p" "proyecto" plain
                "* Objetivo\n%?\n\n* Tareas\n** TODO \n\n* Recursos\n\n* Notas\n"
                :target (file+head "%<%Y%m%d%H%M%S>-''${slug}.org" "#+title: ''${title}\n#+filetags: :proyecto:\n#+date: %U\n\n")
                :unnarrowed t)))
        
        ;; Atajos de teclado
        (global-set-key (kbd "C-c n f") 'org-roam-node-find)
        (global-set-key (kbd "C-c n i") 'org-roam-node-insert)
        (global-set-key (kbd "C-c n c") 'org-roam-capture)
        (global-set-key (kbd "C-c n g") 'org-roam-ui-open)

        ;; =====================================================
        ;; ORG-ROAM-UI: El grafo interactivo que buscas
        ;; =====================================================
        (use-package org-roam-ui
          :after org-roam
          ;; Asegúrate que el servidor se cierre cuando cierres Emacs
          :hook (after-init . org-roam-ui-mode)
          :config
          (setq org-roam-ui-sync-theme t)
          (setq org-roam-ui-follow t)
          (setq org-roam-ui-update-on-save t)
          (setq org-roam-ui-open-on-start nil)) ; Ponlo en 't' si quieres que se abra al iniciar
                
        ;; Inicializar la base de datos
        (org-roam-db-autosync-mode))

      ;; =====================================================
      ;; DEFT: Búsqueda rápida de notas
      ;; =====================================================

      (use-package deft
        :config
        ;; Directorio de búsqueda
        (setq deft-directory "~/notas/")
        
        ;; Extensiones de archivo
        (setq deft-extensions '("org" "txt" "md"))
        
        ;; Usar nombres de archivo como títulos
        (setq deft-use-filename-as-title t)
        
        ;; Búsqueda incremental
        (setq deft-incremental-search t)
        
        ;; Atajo de teclado
        (global-set-key (kbd "C-c d") 'deft))

      ;; =====================================================
      ;; ORG-JOURNAL: Diario personal
      ;; =====================================================

      (use-package org-journal
        :config
        ;; Directorio del diario
        (setq org-journal-dir "~/notas/diario/")
        
        ;; Un archivo por día
        (setq org-journal-file-type 'daily)
        
        ;; Formato de fecha
        (setq org-journal-date-format "%A, %d de %B de %Y")
        
        ;; Plantilla para entradas
        (setq org-journal-file-header "#+title: Diario %<%Y-%m-%d>\n#+date: %U\n\n")
        
        ;; Atajo de teclado
        (global-set-key (kbd "C-c j") 'org-journal-new-entry))

      ;; =====================================================
      ;; PDF-TOOLS: Anotaciones en PDFs
      ;; =====================================================

      (use-package pdf-tools
        :config
        ;; Inicializar PDF-tools
        (pdf-tools-install)
        
        ;; Usar pdf-tools para archivos PDF
        (setq-default pdf-view-display-size 'fit-width))

      (use-package org-noter
        :config
        ;; Directorio para notas de PDFs
        (setq org-noter-notes-search-path '("~/notas/pdfs/"))
        
        ;; Crear notas automáticamente
        (setq org-noter-auto-save-last-location t))

      ;; =====================================================
      ;; MEJORAS VISUALES Y TEMA
      ;; =====================================================

      ;; Tema oscuro moderno
      (use-package doom-themes
        :config
        (load-theme 'doom-one t)
        ;; Mejorar org-mode con el tema
        (doom-themes-org-config))

      ;; Fuentes mejoradas
      (set-face-attribute 'default nil :font "Fira Code" :height 120)
      (set-face-attribute 'variable-pitch nil :font "Inter" :height 120)
      (set-face-attribute 'org-document-title nil :font "Inter" :weight 'bold :height 1.3)

      ;; Configuración visual básica
      (menu-bar-mode -1)          ; Quitar barra de menú
      (tool-bar-mode -1)          ; Quitar barra de herramientas
      (scroll-bar-mode -1)        ; Quitar barra de scroll
      (column-number-mode t)      ; Mostrar número de columna
      (global-display-line-numbers-mode t) ; Números de línea

      ;; Org-mode más bonito
      (use-package org-modern
        :hook (org-mode . org-modern-mode)
        :config
        (setq org-modern-checkbox nil)
        (setq org-modern-table-vertical 1)
        (setq org-modern-table-horizontal 0.2)
        (setq org-modern-star 'replace)
        (setq org-modern-hide-stars t)
        (setq org-modern-keyword t)
        (setq org-modern-list '((?+ . "•") (?- . "•") (?* . "•"))))

      ;; Centrar texto para mejor lectura
      (use-package olivetti
        :hook (org-mode . olivetti-mode)
        :config
        (setq olivetti-body-width 80))

      ;; Mostrar caracteres especiales de org de forma bonita
      (use-package org-appear
        :hook (org-mode . org-appear-mode)
        :config
        (setq org-appear-autolinks t)
        (setq org-appear-autosubmarkers t))

      ;; Dashboard de inicio
      (use-package dashboard
        :config
        (dashboard-setup-startup-hook)
        (setq dashboard-startup-banner 'logo)
        (setq dashboard-items '((recents  . 5)
                              (bookmarks . 5)
                              (agenda . 5))))

      ;; =====================================================
      ;; BÚSQUEDA AVANZADA
      ;; =====================================================

      (use-package consult
        :config
        ;; Búsqueda en notas
        (global-set-key (kbd "C-c s") 'consult-ripgrep))

      (use-package consult-org-roam
        :after org-roam
        :config
        (global-set-key (kbd "C-c n s") 'consult-org-roam-search))

      ;; =====================================================
      ;; AYUDA Y NAVEGACIÓN
      ;; =====================================================

      (use-package which-key
        :init
        (which-key-mode)
        :config
        ;; Mostrar atajos de teclado disponibles
        (setq which-key-idle-delay 0.3))
    '';
  };
  
  # Paquetes adicionales necesarios
  home.packages = with pkgs; [
    # Para PDF-tools
    poppler
    # Para gráficos org-roam
    graphviz
    sqlite
  ];
}