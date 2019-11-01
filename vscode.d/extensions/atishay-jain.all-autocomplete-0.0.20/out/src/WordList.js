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
const Settings_1 = require("./Settings");
const CompletionItem_1 = require("./CompletionItem");
class WordListClass extends Map {
    /**
     * Add word to the autocomplete list
     *
     * @param {string} word
     * @param {any} trie
     * @param {vscode.TextDocument} document
     */
    addWord(word, trie, document) {
        word = word.replace(Settings_1.Settings.whitespaceSplitter(document.languageId), '');
        // Active word is used to hide the given word from the autocomplete.
        this.activeWord = word;
        if (Settings_1.Settings.ignoredWords.indexOf(word) !== -1)
            return;
        if (word.length >= Settings_1.Settings.minWordLength) {
            let items = trie.find(word);
            let item;
            items && items.some(elem => {
                if (elem.label === word) {
                    item = elem;
                    return true;
                }
            });
            if (item) {
                item.count++;
            }
            else {
                item = new CompletionItem_1.CompletionItem(word, document.fileName);
                trie.add(word, item);
            }
        }
    }
    /**
     * Remove word from the search index.
     *
     * @param {string} word
     * @param {any} trie
     */
    removeWord(word, trie, document) {
        word = word.replace(Settings_1.Settings.whitespaceSplitter(document.languageId), '');
        if (word.length >= Settings_1.Settings.minWordLength) {
            let items = trie.find(word);
            let item;
            items && items.some(elem => {
                if (elem.label === word) {
                    item = elem;
                    return true;
                }
            });
            if (item && item.label === word) {
                item.count--;
                if (item.count <= 0) {
                    trie.remove(word);
                }
            }
        }
    }
}
exports.WordList = new WordListClass();
//# sourceMappingURL=WordList.js.map