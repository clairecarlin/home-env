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
const DocumentManager_1 = require("./DocumentManager");
/**
 * Implements the CompletionItem returned by autocomplete
 *
 * @class CompletionItem
 * @extends {vscode.CompletionItem}
 */
class CompletionItem extends vscode.CompletionItem {
    constructor(word, file) {
        super(word);
        this.kind = vscode.CompletionItemKind.Text;
        this.count = 1;
        this.file = file;
    }
    get detail() {
        return `${DocumentManager_1.DocumentManager.documentDisplayPath(this.file)} (${this.count})`;
    }
    get documentation() {
        return this.details.join("\n");
    }
    static copy(item) {
        let newItem = new CompletionItem(item.label, item.file);
        newItem.count = item.count;
        newItem.details = item.details;
        return newItem;
    }
}
exports.CompletionItem = CompletionItem;
//# sourceMappingURL=CompletionItem.js.map