;;; ox-hugo-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:



;;; Generated autoloads from org-hugo-auto-export-mode.el

(autoload 'org-hugo-auto-export-mode "org-hugo-auto-export-mode" "\
Toggle auto exporting the Org file using `ox-hugo'.

This is a minor mode.  If called interactively, toggle the
`Org-Hugo-Auto-Export mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable the
mode if ARG is nil, omitted, or is a positive number.  Disable the mode
if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate the variable `org-hugo-auto-export-mode'.

The mode's hook is called both when the mode is enabled and when it is
disabled.

(fn &optional ARG)" t)
(register-definition-prefixes "org-hugo-auto-export-mode" '("org-hugo-export-wim-to-md-after-save"))


;;; Generated autoloads from ox-blackfriday.el

(autoload 'org-blackfriday-export-as-markdown "ox-blackfriday" "\
Export current buffer to a Github Flavored Markdown buffer.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the heading properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

Export is done in a buffer named \"*Org BLACKFRIDAY Export*\", which will
be displayed when `org-export-show-temporary-export-buffer' is
non-nil.

(fn &optional ASYNC SUBTREEP VISIBLE-ONLY)" t)
(autoload 'org-blackfriday-convert-region-to-md "ox-blackfriday" "\
Convert text in the current region to Blackfriday Markdown.
The text is assumed to be in Org mode format.

This can be used in any buffer.  For example, you can write an
itemized list in Org mode syntax in a Markdown buffer and use
this command to convert it." t)
(autoload 'org-blackfriday-export-to-markdown "ox-blackfriday" "\
Export current buffer to a Github Flavored Markdown file.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the heading properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

Return output file's name.

(fn &optional ASYNC SUBTREEP VISIBLE-ONLY)" t)
(autoload 'org-blackfriday-publish-to-blackfriday "ox-blackfriday" "\
Publish an Org file to Blackfriday Markdown file.

PLIST is the property list for the given project.  FILENAME is
the filename of the Org file to be published.  PUB-DIR is the
publishing directory.

Return output file name.

(fn PLIST FILENAME PUB-DIR)")
(register-definition-prefixes "ox-blackfriday" '("org-blackfriday-"))


;;; Generated autoloads from ox-hugo.el

 (put 'org-hugo-base-dir 'safe-local-variable 'stringp)
 (put 'org-hugo-content-folder 'safe-local-variable 'stringp)
 (put 'org-hugo-goldmark 'safe-local-variable 'booleanp)
 (put 'org-hugo-headline-anchor 'safe-local-variable 'booleanp)
 (put 'org-hugo-section 'safe-local-variable 'stringp)
 (put 'org-hugo-front-matter-format 'safe-local-variable 'stringp)
 (put 'org-hugo-footer 'safe-local-variable 'stringp)
 (put 'org-hugo-preserve-filling 'safe-local-variable 'booleanp)
 (put 'org-hugo-delete-trailing-ws 'safe-local-variable 'booleanp)
 (put 'org-hugo-use-code-for-kbd 'safe-local-variable 'booleanp)
 (put 'org-hugo-allow-spaces-in-tags 'safe-local-variable 'booleanp)
 (put 'org-hugo-prefer-hyphen-in-tags 'safe-local-variable 'booleanp)
 (put 'org-hugo-auto-set-lastmod 'safe-local-variable 'booleanp)
 (put 'org-hugo-suppress-lastmod-period 'safe-local-variable 'floatp)
 (put 'org-hugo-export-with-toc 'safe-local-variable (lambda (x) (or (booleanp x) (integerp x))))
 (put 'org-hugo-export-with-section-numbers 'safe-local-variable (lambda (x) (or (booleanp x) (equal 'onlytoc x) (integerp x))))
 (put 'org-hugo-default-static-subdirectory-for-externals 'safe-local-variable 'stringp)
 (put 'org-hugo-export-creator-string 'safe-local-variable 'stringp)
 (put 'org-hugo-date-format 'safe-local-variable 'stringp)
 (put 'org-hugo-paired-shortcodes 'safe-local-variable 'stringp)
 (put 'org-hugo-link-desc-insert-type 'safe-local-variable 'booleanp)
 (put 'org-hugo-container-element 'safe-local-variable 'stringp)
(autoload 'org-hugo-slug "ox-hugo" "\
Convert string STR to a `slug' and return that string.

A `slug' is the part of a URL which identifies a particular page
on a website in an easy to read form.

Example: If STR is \"My First Post\", it will be converted to a
slug \"my-first-post\", which can become part of an easy to read
URL like \"https://example.com/posts/my-first-post/\".

In general, STR is a string.  But it can also be a string with
Markdown markup because STR is often a post's sub-heading (which
can contain bold, italics, link, etc markup).

The `slug' generated from that STR follows these rules:

- Contain only lower case alphabet, number and hyphen characters
  ([[:alnum:]-]).
- Not have *any* HTML tag like \"<code>..</code>\",
  \"<span class=..>..</span>\", etc.
- Not contain any URLs (if STR happens to be a Markdown link).
- Replace \".\" in STR with \"dot\", \"&\" with \"and\",
  \"+\" with \"plus\".
- Replace parentheses with double-hyphens.  So \"foo (bar) baz\"
  becomes \"foo--bar--baz\".
- Replace non [[:alnum:]-] chars with spaces, and then one or
  more consecutive spaces with a single hyphen.
- If ALLOW-DOUBLE-HYPHENS is non-nil, at most two consecutive
  hyphens are allowed in the returned string, otherwise consecutive
  hyphens are not returned.
- No hyphens allowed at the leading or trailing end of the slug.

(fn STR &optional ALLOW-DOUBLE-HYPHENS)")
(autoload 'org-hugo-export-as-md "ox-hugo" "\
Export current buffer to a Hugo-compatible Markdown buffer.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the heading properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

Export is done in a buffer named \"*Org Hugo Export*\", which
will be displayed when `org-export-show-temporary-export-buffer'
is non-nil.

Return the buffer the export happened to.

(fn &optional ASYNC SUBTREEP VISIBLE-ONLY)" t)
(autoload 'org-hugo-export-to-md "ox-hugo" "\
Export current buffer to a Hugo-compatible Markdown file.

This is the main exporting function which is called by both
`org-hugo--export-file-to-md' and
`org-hugo--export-subtree-to-md', and thus
`org-hugo-export-wim-to-md' too.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the heading properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

Return output file's name.

(fn &optional ASYNC SUBTREEP VISIBLE-ONLY)" t)
(autoload 'org-hugo-export-wim-to-md "ox-hugo" "\
Export the current subtree/all subtrees/current file to a Hugo post.

This is an Export \"What I Mean\" function:

- If the current subtree has the \"EXPORT_FILE_NAME\" property,
  export only that subtree.  Return the return value of
  `org-hugo--export-subtree-to-md'.

- If the current subtree doesn't have that property, but one of
  its parent subtrees has, export from that subtree's scope.
  Return the return value of `org-hugo--export-subtree-to-md'.

- If there are no valid Hugo post subtrees (that have the
  \"EXPORT_FILE_NAME\" property) in the Org buffer the subtrees
  have that property, do file-based
  export (`org-hugo--export-file-to-md'), regardless of the value
  of ALL-SUBTREES.  Return the return value of
  `org-hugo--export-file-to-md'.

- If ALL-SUBTREES is non-nil and the Org buffer has at least 1
  valid Hugo post subtree, export all those valid post subtrees.
  Return a list of output files.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

The optional argument NOERROR is passed to
`org-hugo--export-file-to-md'.

(fn &optional ALL-SUBTREES ASYNC VISIBLE-ONLY NOERROR)" t)
(autoload 'org-hugo-debug-info "ox-hugo" "\
Get Emacs, Org and Hugo version and ox-hugo customization info.
The information is converted to Markdown format and copied to the
kill ring.  The same information is displayed in the Messages
buffer and returned as a string in Org format." t)
(register-definition-prefixes "ox-hugo" '("org-hugo-"))


;;; Generated autoloads from ox-hugo-deprecated.el

(register-definition-prefixes "ox-hugo-deprecated" '("org-hugo-"))


;;; Generated autoloads from ox-hugo-pandoc-cite.el

(register-definition-prefixes "ox-hugo-pandoc-cite" '("org-hugo-pandoc-cite-"))

;;; End of scraped data

(provide 'ox-hugo-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; ox-hugo-autoloads.el ends here
