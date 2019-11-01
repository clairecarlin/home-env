/**
 * COPYRIGHT 2017 Atishay Jain<contact@atishay.me>
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const CompletionItemProvider_1 = require("./CompletionItemProvider");
const Settings_1 = require("./Settings");
const WordList_1 = require("./WordList");
const Utils_1 = require("./Utils");
const DocumentManager_1 = require("./DocumentManager");
const vscode_1 = require("vscode");
let content = [];
/**
 * Utility class to manage the active document
 *
 * @class ActiveDocManager
 */
class ActiveDocManager {
    static beginTransaction() { }
    static endTransaction(updated) {
        if (updated) {
            return;
        }
        ActiveDocManager.updateContent();
    }
    static updateContent() {
        if (!vscode_1.window.activeTextEditor || !vscode_1.window.activeTextEditor.document) {
            return;
        }
        content = [];
        let doc = vscode_1.window.activeTextEditor.document;
        if (Utils_1.shouldExcludeFile(doc.fileName)) {
            return;
        }
        for (let i = 0; i < doc.lineCount; ++i) {
            content.push(doc.lineAt(i).text);
        }
    }
    /**
     * Gets content replacement information for range replacement
     *
     * @static
     * @param {Range} r
     * @param {string} newText
     * @returns {new:string, old:string}
     *
     * @memberof ActiveDocManager
     */
    static replace(r, newText, noOfChangesInTransaction) {
        // Find old text
        let line = content[r.start.line] || "";
        // Get the closest space to the left and right;
        // Start is the actual start wordIndex
        let start;
        for (start = r.start.character - 1; start > 0; --start) {
            if ((line[start] || "").match(Settings_1.Settings.whitespaceSplitter(vscode_1.window.activeTextEditor.document.languageId))) {
                start = start + 1;
                break;
            }
        }
        // End is the actual end wordIndex
        let end;
        let nLine = content[r.end.line] || "";
        for (end = r.end.character; end < nLine.length; ++end) {
            if ((nLine[end] || "").match(/\s/)) {
                end = end;
                break;
            }
        }
        let oldText = "";
        if (r.isSingleLine) {
            oldText = line.substring(start, end);
        }
        else {
            let oldText = nLine.substring(start);
            for (let i = r.start.line + 1; i < r.end.line; ++i) {
                oldText += "\n" + content[i];
            }
            oldText += nLine.substring(0, end);
        }
        const nwText = line.substring(start, r.start.character) + newText + nLine.substring(r.end.character, end);
        let updated = false;
        if (noOfChangesInTransaction === 1 && r.isSingleLine) {
            // Special case. Optimize for a single cursor in a single line as that is too frequent to do a re-read.
            const newLine = line.substring(0, r.start.character) + newText + nLine.substring(r.end.character);
            const n = newLine.split(vscode_1.window.activeTextEditor.document.eol === vscode.EndOfLine.LF ? "\n" : "\r\n");
            content[r.start.line] = n[0];
            for (let i = 1; i < n.length; ++i) {
                content.splice(r.start.line + i, 0, n[i]);
            }
            updated = true;
        }
        return {
            old: oldText.split(Settings_1.Settings.whitespaceSplitter(vscode_1.window.activeTextEditor.document.languageId)),
            new: nwText.split(Settings_1.Settings.whitespaceSplitter(vscode_1.window.activeTextEditor.document.languageId)),
            updated: updated
        };
    }
    /**
     * Handle content changes to active document
     *
     * @static
     * @param {TextDocumentChangeEvent} e
     * @returns
     *
     * @memberof ActiveDocManager
     */
    static handleContextChange(e) {
        const activeIndex = WordList_1.WordList.get(e.document);
        if (!activeIndex) {
            console.log("No index found");
            return;
        }
        if (e.document !== vscode_1.window.activeTextEditor.document) {
            console.log("Unexpected Active Doc. Parsing broken");
            return;
        }
        ActiveDocManager.beginTransaction();
        let updated = true;
        e.contentChanges.forEach((change) => {
            let diff = ActiveDocManager.replace(change.range, change.text, e.contentChanges.length);
            diff.old.forEach((string) => {
                WordList_1.WordList.removeWord(string, activeIndex, e.document);
            });
            diff.new.forEach((string) => {
                WordList_1.WordList.addWord(string, activeIndex, e.document);
            });
            updated = updated && diff.updated;
        });
        ActiveDocManager.endTransaction(updated);
    }
}
let olderActiveDocument;
/**
 * Handle setting of the new active document
 */
function handleNewActiveEditor() {
    if (Settings_1.Settings.showCurrentDocument) {
        ActiveDocManager.updateContent();
    }
    else {
        if (olderActiveDocument) {
            DocumentManager_1.DocumentManager.resetDocument(olderActiveDocument);
        }
        olderActiveDocument = vscode_1.window.activeTextEditor ? vscode_1.window.activeTextEditor.document : null;
    }
}
/**
 * On extension activation register the autocomplete handler.
 *
 * @export
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
    Settings_1.Settings.init();
    DocumentManager_1.DocumentManager.init();
    /**
     * Mark all words when the active document changes.
     */
    function attachActiveDocListener() {
        if (!Settings_1.Settings.updateOnlyOnSave) {
            context.subscriptions.push(vscode_1.window.onDidChangeActiveTextEditor((newDoc) => {
                handleNewActiveEditor();
            }));
            handleNewActiveEditor();
        }
    }
    vscode.languages.getLanguages().then((languages) => {
        languages.push('*');
        languages = languages.filter((x) => x.toLowerCase() !== "php");
        context.subscriptions.push(vscode.languages.registerCompletionItemProvider(languages, CompletionItemProvider_1.CompletionItemProvider));
        context.subscriptions.push(vscode.languages.registerCompletionItemProvider("php", CompletionItemProvider_1.CompletionItemProvider, ..."$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"));
    });
    context.subscriptions.push(vscode.commands.registerCommand("AllAutocomplete.cycleDocuments", () => {
        Utils_1.findActiveDocsHack();
    }));
    context.subscriptions.push(vscode.commands.registerCommand("AllAutocomplete.toggleCurrentFile", () => {
        const config = vscode.workspace.getConfiguration('AllAutocomplete');
        if (Settings_1.Settings.showCurrentDocument) {
            config.update("showCurrentDocument", false);
            Settings_1.Settings.showCurrentDocument = false;
        }
        else {
            config.update("showCurrentDocument", true);
            Settings_1.Settings.showCurrentDocument = true;
            let currentDocument = vscode_1.window.activeTextEditor ? vscode_1.window.activeTextEditor.document : null;
            if (currentDocument) {
                DocumentManager_1.DocumentManager.resetDocument(currentDocument);
                ActiveDocManager.updateContent();
            }
        }
    }));
    context.subscriptions.push(vscode_1.workspace.onDidOpenTextDocument((document) => {
        DocumentManager_1.DocumentManager.parseDocument(document);
    }));
    context.subscriptions.push(vscode_1.workspace.onDidCloseTextDocument((document) => {
        if (olderActiveDocument === document) {
            olderActiveDocument = null;
        }
        DocumentManager_1.DocumentManager.clearDocument(document);
    }));
    context.subscriptions.push(vscode_1.workspace.onDidChangeTextDocument((e) => {
        if (Utils_1.shouldExcludeFile(e.document.fileName)) {
            return;
        }
        if (!Settings_1.Settings.updateOnlyOnSave && Settings_1.Settings.showCurrentDocument && e.contentChanges.length > 0) {
            ActiveDocManager.handleContextChange(e);
        }
    }));
    if (Settings_1.Settings.updateOnlyOnSave) {
        context.subscriptions.push(vscode_1.workspace.onDidSaveTextDocument((document) => {
            DocumentManager_1.DocumentManager.resetDocument(document);
        }));
    }
    for (let i = 0; i < vscode_1.workspace.textDocuments.length; ++i) {
        // Parse all words in this document
        DocumentManager_1.DocumentManager.parseDocument(vscode_1.workspace.textDocuments[i]);
    }
    // All open editors are not available: https://github.com/Microsoft/vscode/issues/15178
    if (Settings_1.Settings.cycleOpenDocumentsOnLaunch) {
        Utils_1.findActiveDocsHack().then(attachActiveDocListener);
    }
    else {
        attachActiveDocListener();
    }
}
exports.activate = activate;
/**
 * Free up everything on deactivation
 *
 * @export
 */
function deactivate() {
    WordList_1.WordList.clear();
    content = [];
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map