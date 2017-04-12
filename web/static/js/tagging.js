import utils from './utils';
import { request } from './request';

export function tagging(target, options) {

    let isLoading = false;
    let currentIndex = -1;
    let inputElement = document.createElement('input');
    let optionsWrapper = document.createElement('ul');
    let tagsWrapper = document.createElement('ul');
    let hiddenInputWrapper = document.createElement('div');
    let tagsList = [];
    let optionsList = [];

    function createTag(tag, callback) {
        request('/api/tags', {
            method: 'POST',
            body: { tag: tag }
        }, callback);
    }

    function listTags(query, callback) {
        request('/api/tags', { query: query }, callback);
    }

    function clearOptions() {
        while (optionsWrapper.firstChild) {
            optionsWrapper.removeChild(optionsWrapper.firstChild);
        }
    }

    function createOption(option) {
        let optionElement = document.createElement('li');
        optionElement.classList.add('option');
        optionElement.textContent = option.name;
        optionsWrapper.append(optionElement);
    }

    function genNextIndex(step) {
        // step only support 1 or -1;
        let nextIndex;
        if (step === 1) {
            nextIndex = currentIndex === optionsList.length - 1 ? 0 : currentIndex + 1;
        } else {
            nextIndex = currentIndex === 0 ? optionsList.length - 1 : currentIndex - 1;
        }

        return nextIndex;
    }

    function setCurrentIndex(index) {
        if (optionsList.length > 0 && currentIndex !== -1)
            optionsWrapper.children[currentIndex].classList.remove('active');

        if (optionsList.length > 0 && index !== -1)
            optionsWrapper.children[index].classList.add('active');

        currentIndex = index;
    }

    function createTagElement(tag) {
        let tagElement = document.createElement('li');
        tagElement.classList.add('tag');
        tagElement.textContent = tag.name;
        tagElement.dataset.id = tag.id;

        let close = document.createElement('span');
        close.classList.add('close');
        close.textContent = 'x';

        tagElement.append(close);
        tagsWrapper.append(tagElement);
        createHiddenInputElement(tag);
    }

    function createHiddenInputElement(tag) {
        let hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = options.name;
        hiddenInput.value = tag.id;
        hiddenInputWrapper.append(hiddenInput);
    }

    function removeTagElement(tagElement) {
        let tagId = tagElement.dataset.id;
        let hiddenInputElement = hiddenInputWrapper.querySelector('input[value="' + tagId + '"]')

        hiddenInputWrapper.removeChild(hiddenInputElement);
        tagsWrapper.removeChild(tagElement);
    }

    function onTagsWrapperClick(e) {
        if (e.target.classList.contains('close')) {
            let tagElement = e.target.parentElement;
            removeTagElement(tagElement);
        }
    }

    function onKeyup(e) {

        if (e.which === 38 || e.which === 40) return;

        let input = e.target.value;

        if (e.which === 13) {
            e.preventDefault();
            tagsList.push(tagsList[currentIndex]);
            createTagElement(optionsList[currentIndex]);
            inputElement.value = '';
            clearOptions();
            // createTag({ name: input }, function (err, res) {
            //     console.log(err, res);
            // });
        } else {
            request('/api/tags', { query: { name: input } }, function (err, res) {
                clearOptions();
                optionsList = res.data;
                res.data.forEach(item => createOption(item));
                setCurrentIndex(optionsList.length > 0 ? 0 : -1);
            });
        }
    }

    function onKeydown(e) {
        // enter
        if (e.which === 13) {
            e.preventDefault();
        }

        // up
        if (e.which === 38) {
            e.preventDefault();
            setCurrentIndex(genNextIndex(-1));
        }

        // down
        if (e.which === 40) {
            e.preventDefault();
            setCurrentIndex(genNextIndex(1));
        }
    }

    target.classList.add('tagging');
    target.append(tagsWrapper);
    target.append(hiddenInputWrapper);
    target.append(inputElement);
    target.append(optionsWrapper);
    inputElement.addEventListener('keyup', onKeyup);
    inputElement.addEventListener('keydown', onKeydown);
    tagsWrapper.addEventListener('click', onTagsWrapperClick);
}
