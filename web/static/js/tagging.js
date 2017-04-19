import utils from './utils';
import { request } from './request';

export function tagging(target, options) {

    let isLoading = false;
    let currentIndex = -1;
    let inputElement = document.createElement('input');
    let optionsWrapper = document.createElement('ul');
    let tagsWrapper = document.createElement('ul');
    let tagsList = options.tags || [];
    let optionsList = [];

    function createTag(tag) {
        request('/api/tags', {
            method: 'POST',
            body: { tag: tag }
        }, function (err, res) {
            tagsList.push(res.data);
            createTagElement(res.data);
            inputElement.value = '';
            clearOptions();
        });
    }

    function onGetTags(query) {
        request('/api/tags', { query: query }, function (err, res) {
            clearOptions();
            optionsList = [];
            res.data.forEach(item => {
                let isExist = tagsList.filter(t => t.id === item.id).length > 0;
                if (!isExist) {
                    createOption(item);
                    optionsList.push(item);
                }
            });

            if (optionsList.filter(o => o.name === query.name).length === 0) {
                let o = { name: '创建新标签：' + query.name };
                createOption(o);
                optionsList.push(o);
            }

            setCurrentIndex(optionsList.length > 0 ? 0 : -1);
        });
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

        let close = document.createElement('span');
        close.classList.add('close');
        close.textContent = 'x';

        let hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = options.name;
        hiddenInput.value = tag.id;

        tagElement.append(close);
        tagElement.append(hiddenInput);
        tagsWrapper.append(tagElement);
    }

    function removeTagElement(tagElement) {
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

            let tag = optionsList[currentIndex];

            if (typeof tag.id === 'undefined') {
                createTag(tag);
            } else {
                tagsList.push(optionsList[currentIndex]);
                createTagElement(optionsList[currentIndex]);
                inputElement.value = '';
                clearOptions();
            }
        } else {
            onGetTags({ name: input });
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
    target.append(inputElement);
    target.append(optionsWrapper);
    inputElement.addEventListener('keyup', onKeyup);
    inputElement.addEventListener('keydown', onKeydown);
    tagsWrapper.addEventListener('click', onTagsWrapperClick);

    // initialize tags
    tagsList.length > 0 && tagsList.forEach(t => createTagElement(t));
}
