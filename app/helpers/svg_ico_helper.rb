module SvgIcoModule

  def svg_ico(name, size, style=nil)
    # http://iconmonstr.com/
    # desn gumb, copy path i vozi

    # http://icomoon.io/app/#/select
    # ukljuciti edit opciju, download kao svg, izvuci path

    # ako nema : onda je valjda poslan color
    style = "fill:#{style}" if style && style.to_s !~ /:/

    iconmonstr = {
      gear:'M462,218.118h-25.804c-5.604,0-25.814-3.535-33.274-23.529c-7.459-19.993,3.027-34.632,7.419-39.024 c3.11-3.11,18.252-18.247,18.252-18.247l-53.856-53.904c0,0-14.298,14.301-18.259,18.26c-3.962,3.963-20.53,15.821-39.944,6.96 c-19.409-8.862-22.156-26.596-22.156-32.807c0-6.208,0-25.826,0-25.826H217.34c0,0,0,20.21,0,25.812 c0,5.603-3.124,25.815-23.117,33.273c-19.994,7.458-34.423-3.025-38.812-7.417c-0.01-0.007-18.165-18.261-18.165-18.261 l-54.102,53.856l18.139,18.373c5.705,5.765,15.851,20.59,7.021,39.925c-8.839,19.365-26.372,21.891-32.618,21.904 c-0.004,0.017-25.685,0-25.685,0v77.69c0,0,20.202,0,25.804,0c5.604,0,25.551,2.9,33.009,22.891 c7.458,19.997-2.703,33.704-7.437,38.396l-18.233,18.382l54.086,53.797c0,0,14.327-14.307,18.29-18.27 c3.962-3.962,20.392-15.835,39.803-6.97c19.414,8.86,22.019,26.577,22.019,32.788s0,25.829,0,25.829h77.037c0,0,0-20.211,0-25.812 c0-5.604,3.267-25.816,23.261-33.274c19.991-7.458,34.493,3.026,38.884,7.419c0.005,0.004-0.003,0.008-0.01,0.012l18.235,18.249 l53.971-53.856l-18.132-18.252c-3.917-4.05-15.858-20.715-7.031-40.047c8.842-19.366,26.443-21.92,32.694-21.936 c0.002-0.014,25.751,0,25.751,0V218.118z M256.008,332.04c-42.005,0-76.049-34.043-76.049-76.042 c0-41.994,34.044-76.042,76.049-76.042c41.994,0,76.036,34.048,76.036,76.042C332.044,297.997,298.002,332.04,256.008,332.04z',
      note:'M370.845,339.166H209.821v-30h161.023V339.166z M370.845,280.749H209.821v-30h161.023V280.749z M370.845,223.416H209.821v-30h161.023V223.416z M170.166,421.825V156.714H409.5c0,0,0,133.5,0,165.25 c0,50.953-70.109,33.833-70.109,33.833s16.609,66.028-32,66.028C275.328,421.825,288.508,421.825,170.166,421.825z M449.5,320.417 V116.714H130.166v345.111H308C376.165,461.825,449.5,381.819,449.5,320.417z M97.5,420.942V85.333h311V50.175h-346v370.768H97.5z',
      link:'M343.84,322.343h41.396c-20,31.632-73.736,53.052-109.208,53.052c0,0,0-23.33,0-52.823 c22.465-6.896,46.214-20.909,68.93-44.067l-21.416-21.008c-13.17,13.426-29.94,25.492-47.514,32.914c0-22.368,0-44.844,0-61.4 c16.38-2.595,50.336-5.342,76.879-27.027c15.137-12.366,24.03-28.485,25.042-45.39c1.581-26.413-15.741-49.305-43.436-58.024 c1.471,10.861,0.688,21.856-1.868,31.578c10.146,5.415,15.969,14.434,15.357,24.654c-1.757,29.319-42.816,39.553-71.821,43.824 c2.616-40.536,39.072-47.251,39.072-89.371C315.254,76.528,288.725,50,256,50s-59.254,26.528-59.254,59.254 c0,44.615,39.226,46.881,39.226,97.365c-31.604,8.54-57.924,22.881-65.424,49.864c-9.53,34.286,18.546,68.332,65.424,71.173 c0,27.045,0,47.738,0,47.738c-35.472,0-89.208-21.42-109.208-53.052h41.396L78.5,267v104.686l22.514-31.961 C148.981,419.659,214.252,416.145,256,462c41.748-45.855,107.019-42.341,154.986-122.275l22.514,31.961V267L343.84,322.343z M229.672,109.254c0-14.518,11.811-26.329,26.328-26.329s26.328,11.812,26.328,26.329S270.518,135.582,256,135.582 S229.672,123.771,229.672,109.254z M235.972,237.906c0,17.314,0,38.971,0,59.938C196.623,294.425,176.699,256.648,235.972,237.906z',
      comment:'M174.059,354.374c-0.031-0.008-0.062-0.014-0.093-0.021 c-25.892,15.965-82.983,32.107-123.141,39.412c14.984-29.725,31.616-70.527,30.764-98.977C61.403,270.511,50,239.224,50,207.358 c0-89.84,87.383-155.527,185.209-155.527c97.22,0,185.211,65.193,185.211,155.527c0,1.283-0.027,2.564-0.066,3.844 c-11.285-6.088-23.506-11.037-36.622-14.68c-6.854-60.861-70.842-108.715-148.522-108.715c-82.237,0-149.141,53.631-149.141,119.551 c0,34.688,15.009,56.529,36.192,78.068c-4.306,31.98-14.646,59.781-14.646,59.781s30.542-8.064,65.253-28.275 C171.395,329.616,171.806,342.101,174.059,354.374z M461.432,460.169c-27.634-5.029-66.922-16.137-84.739-27.123 c-98.102,24.029-169.6-36.424-169.6-101.154c0-62.166,60.552-107.029,127.453-107.029c67.322,0,127.454,45.203,127.454,107.029 c0,21.928-7.85,43.457-21.738,60.164C439.674,411.634,451.121,439.712,461.432,460.169z M302.524,333.198 c0-9.648-7.841-17.469-17.515-17.469c-9.673,0-17.515,7.82-17.515,17.469s7.842,17.471,17.515,17.471 C294.684,350.669,302.524,342.847,302.524,333.198z M354.75,333.198c0-9.648-7.841-17.469-17.515-17.469 c-9.673,0-17.515,7.82-17.515,17.469s7.842,17.471,17.515,17.471C346.909,350.669,354.75,342.847,354.75,333.198z M406.339,333.198 c0-9.648-7.842-17.469-17.515-17.469c-9.674,0-17.515,7.82-17.515,17.469s7.841,17.471,17.515,17.471 C398.497,350.669,406.339,342.847,406.339,333.198z',
      discuss:'M440.704,391.771C454.312,375.362,462,354.216,462,332.679c0-35.26-19.864-65.01-49.435-83.766 c4.186-13.053,6.395-26.594,6.395-40.27c0-90.207-87.645-155.312-184.479-155.312C137.037,53.331,50,118.929,50,208.644 c0,31.822,11.358,63.066,31.465,87.309c0.849,28.41-15.719,69.156-30.643,98.842c39.998-7.295,96.866-23.416,122.654-39.357 c15.134,3.717,29.826,6.027,44.007,7.1c17.877,50.588,80.211,89.32,160.944,69.494c17.455,10.789,55.943,21.699,83.016,26.639 C451.342,438.577,440.129,410.999,440.704,391.771z M172.431,318.04c-34.595,20.203-65.042,28.264-65.042,28.264 s10.299-27.762,14.588-59.699c-21.101-21.508-36.05-43.32-36.05-77.961c0-65.83,66.641-119.387,148.554-119.387 c81.912,0,148.554,53.557,148.554,119.387C383.034,276.784,304.718,353.12,172.431,318.04z M418.856,421.499 c0,0-19.577-5.182-41.82-18.172c-65.705,17.422-110.659-7.877-127.746-40.469c70.42-4.076,124.766-40.012,151.465-87.078 c19.564,14.066,31.901,34.5,31.901,57.207c0,22.273-9.612,36.297-23.179,50.127C412.234,403.649,418.856,421.499,418.856,421.499z',
      home:'M419.492,275.815v166.213H300.725v-90.33h-89.451v90.33H92.507V275.815H50L256,69.972l206,205.844H419.492 z M394.072,88.472h-47.917v38.311l47.917,48.023V88.472z',
      file:'M173.443,245.694c0-12.111,9.82-21.932,21.933-21.932c12.111,0,21.932,9.82,21.932,21.932 c0,12.113-9.82,21.933-21.932,21.933C183.264,267.627,173.443,257.808,173.443,245.694z M284.686,248.659l-36.355,51.654 l-19.759-20.364l-55.747,75.149h174.26L284.686,248.659z M297.818,90v85.75h85.864V422H128.317V90H297.818 M322.818,50H88.317v412 h335.365V150.75L322.818,50z',
      table:'M50,73.5v365h412v-365H50z M422,264.528H276V170.5h146V264.528z M236,170.5v94.028H90V170.5H236z M90,304.528h146V398.5H90V304.528z M276,398.5v-93.972h146V398.5H276z',
      users:'M461.957,393.573H355.559c-0.005-115.799-57.887-60.76-57.887-162.232c0-36.629,23.98-56.51,54.772-56.51 c45.495,0,77.158,43.439,34.075,124.666c-14.153,26.684,15.072,33.025,46.469,40.268 C464.372,347.003,461.957,363.55,461.957,393.573z M289.119,325.89c-39.492-9.109-76.254-17.086-58.45-50.652 c54.192-102.17,14.364-156.811-42.862-156.811c-58.354,0-97.202,56.736-42.861,156.811c18.337,33.771-19.809,41.738-58.452,50.652 c-39.476,9.105-36.439,29.918-36.439,67.684h275.505C325.559,355.808,328.596,334.995,289.119,325.89z',
      product:'M235.328,50.334L71.613,144.856v197.226L276.97,461.666l163.417-95.143V169.299L235.328,50.334z M397.19,178.922l-44.827,24.826l-159.416-94.303l42.345-24.448L397.19,178.922z M261,417.686L101.257,324.84V178.98L261,271.447 V417.686z M276.504,245.76l-159.478-92.482l46.102-26.617l158.804,93.941L276.504,245.76z M410.459,349.275L291,418.824V272.025 l119.459-66.158V349.275z M321.13,370.637l-0.1-29.369l5.85-3.406v29.426L321.13,370.637z M383.09,334.562l-4.84,2.818v-29.426 l5.75-3.348v29.42L383.09,334.562z M360.057,347.973l-5.75,3.348v-29.426l5.75-3.348V347.973z M369.844,342.275l-5.851,3.406 v-29.426l5.851-3.406V342.275z M350.438,353.572l-5.756,3.352v-29.426l5.756-3.352V353.572z M336.666,361.59l-5.75,3.348v-29.426 l5.75-3.348V361.59z',
    }

    iconmonstr[:att] = iconmonstr[:file]
    iconmonstr[:topic] = iconmonstr[:discuss]

    icomoon = {
      left: 'M201.373 73.373l-160 160c-12.497 12.496-12.497 32.758 0 45.254l160 160c12.497 12.496 32.758 12.496 45.255 0s12.498-32.758 0-45.254l-105.374-105.373h306.746c17.673 0 32-14.326 32-32s-14.327-32-32-32h-306.746l105.373-105.373c6.248-6.248 9.373-14.438 9.373-22.627s-3.124-16.379-9.372-22.627c-12.498-12.497-32.758-12.497-45.255 0z',
      menu: 'M512 288h-384c-17.664 0-32 14.336-32 32s14.336 32 32 32h384c17.696 0 32-14.336 32-32s-14.304-32-32-32zM128 224h384c17.696 0 32-14.336 32-32s-14.304-32-32-32h-384c-17.664 0-32 14.336-32 32s14.336 32 32 32zM512 416h-384c-17.664 0-32 14.304-32 32s14.336 32 32 32h384c17.696 0 32-14.304 32-32s-14.304-32-32-32z',
      trash:'M467.675 110.517c-1.452-23.77-21-42.639-45.12-42.639h-45.424v-15.174c0-25.089-20.349-45.424-45.424-45.424h-151.413c-25.089 0-45.424 20.335-45.424 45.424v15.156h-45.424c-24.148 0-43.681 18.866-45.136 42.638h-0.288v33.053c0 16.715 13.566 30.283 30.283 30.283v0 257.399c0 33.447 27.12 60.565 60.565 60.565h242.259c33.448 0 60.565-27.12 60.565-60.565v-257.399c16.715 0 30.283-13.566 30.283-30.283v-33.037h-0.301zM165.152 52.724c0-8.373 6.767-15.142 15.142-15.142h151.413c8.373 0 15.142 6.767 15.142 15.142v15.142h-181.695v-15.142zM407.413 431.255c0 16.687-13.599 30.283-30.283 30.283h-242.259c-16.701 0-30.283-13.597-30.283-30.283v-257.399h302.824v257.399zM437.695 128.416v15.142h-363.39v-30.266c0-8.371 6.767-15.142 15.142-15.142h333.107c8.373 0 15.142 6.767 15.142 15.142v15.127zM150.011 431.317h30.285c8.371 0 15.142-6.767 15.142-15.142v-196.835c0-8.373-6.769-15.142-15.142-15.142h-30.285c-8.371 0-15.142 6.767-15.142 15.142v196.835c0 8.373 6.769 15.142 15.142 15.142zM150.011 219.323h30.285v196.835h-30.285v-196.835zM240.858 431.317h30.285c8.373 0 15.142-6.767 15.142-15.142v-196.835c0-8.373-6.767-15.142-15.142-15.142h-30.283c-8.371 0-15.142 6.767-15.142 15.142v196.835c0 8.373 6.769 15.142 15.142 15.142zM240.858 219.323h30.285v196.835h-30.283v-196.835zM331.705 431.317h30.283c8.373 0 15.142-6.767 15.142-15.142v-196.835c0-8.373-6.769-15.142-15.142-15.142h-30.283c-8.373 0-15.142 6.767-15.142 15.142v196.835c0 8.373 6.767 15.142 15.142 15.142zM331.705 219.323h30.283v196.835h-30.283v-196.835z',
      thumb_up:'M464 288c36.5 0 16 96-16 96 16 0 0 80-32 80 0 32-32 48-64 48-135.176 0-87.632-33.825-224-48v-256c120.461-36.134 240-126.712 240-208 26.5 0 96 32 0 192 0 0 80 0 96 0 48 0 32 96 0 96zM96 208v256h32v16h-64c-17.6 0-32-21.6-32-48v-192c0-26.4 14.4-48 32-48h64v16h-32z',
      thumb_down:'M48 224c-36.5 0-16-96 16-96-16 0 0-80 32-80 0-32 32-48 64-48 135.176 0 87.632 33.825 224 48v256c-120.461 36.134-240 126.712-240 208-26.5 0-96-32 0-192 0 0-80 0-96 0-48 0-32-96 0-96zM416 304v-256h-32v-16h64c17.6 0 32 21.6 32 48v192c0 26.4-14.4 48-32 48h-64v-16h32z',
      test:'M512 304.047v-96.094l-73.387-12.231c-2.979-9.066-6.611-17.834-10.847-26.25l43.227-60.517-67.948-67.949-60.413 43.152c-8.455-4.277-17.269-7.944-26.384-10.951l-12.201-73.207h-96.094l-12.201 73.208c-9.115 3.007-17.929 6.674-26.383 10.951l-60.414-43.152-67.949 67.949 43.227 60.518c-4.235 8.415-7.867 17.183-10.846 26.249l-73.387 12.23v96.094l73.559 12.26c2.98 8.984 6.605 17.674 10.821 26.015l-43.374 60.724 67.949 67.948 60.827-43.447c8.301 4.175 16.945 7.764 25.882 10.717l12.289 73.736h96.094l12.289-73.737c8.937-2.953 17.581-6.542 25.883-10.716l60.826 43.446 67.948-67.948-43.372-60.723c4.216-8.341 7.839-17.031 10.82-26.016l73.559-12.259zM256 320c-35.346 0-64-28.653-64-64s28.654-64 64-64c35.347 0 64 28.654 64 64s-28.653 64-64 64z',
      skype:'M476.32 295.472c2.272-12.832 3.68-25.968 3.68-39.472 0-123.712-100.288-224-224-224-13.504 0-26.64 1.408-39.472 3.68-22.992-22.048-54.16-35.68-88.528-35.68-70.688 0-128 57.312-128 128 0 34.368 13.632 65.536 35.68 88.528-2.272 12.832-3.68 25.968-3.68 39.472 0 123.712 100.288 224 224 224 13.504 0 26.64-1.392 39.472-3.68 22.992 22.048 54.16 35.68 88.528 35.68 70.688 0 128-57.312 128-128 0-34.368-13.632-65.536-35.68-88.528zM354.64 345.664c-8.864 12.064-21.92 21.632-38.864 28.384-16.784 6.704-36.88 10.112-59.728 10.112-27.472 0-50.496-4.656-68.464-13.808-12.848-6.688-23.44-15.696-31.488-26.928-8.128-11.264-12.24-22.448-12.24-33.264 0-6.736 2.672-12.56 7.968-17.36 5.232-4.768 11.952-7.136 19.952-7.136 6.576 0 12.256 1.872 16.848 5.632 4.4 3.632 8.176 8.944 11.216 15.776 3.392 7.488 7.072 13.776 10.976 18.72 3.76 4.816 9.152 8.832 16.048 11.968 6.928 3.152 16.288 4.768 27.776 4.768 15.792 0 28.768-3.248 38.512-9.664 9.52-6.256 14.144-13.776 14.144-22.992 0-7.264-2.416-12.992-7.376-17.456-5.216-4.688-12.080-8.336-20.384-10.848-8.704-2.592-20.512-5.456-35.104-8.368-19.84-4.096-36.688-8.944-50.112-14.416-13.712-5.632-24.768-13.424-32.848-23.136-8.208-9.92-12.368-22.304-12.368-36.912 0-13.904 4.368-26.448 12.992-37.248 8.544-10.752 21.040-19.104 37.12-24.816 15.856-5.664 34.736-8.512 56.096-8.512 17.056 0 32.096 1.904 44.624 5.664 12.608 3.76 23.216 8.88 31.6 15.152 8.384 6.336 14.656 13.072 18.576 20.128 3.952 7.072 5.984 14.16 5.984 20.992 0 6.592-2.64 12.56-7.84 17.776-5.248 5.232-11.84 7.888-19.648 7.888-7.072 0-12.624-1.664-16.464-4.928-3.584-3.056-7.296-7.808-11.408-14.64-4.784-8.72-10.544-15.6-17.168-20.448-6.4-4.72-17.152-7.072-31.92-7.072-13.696 0-24.864 2.64-33.12 7.872-7.984 5.024-11.856 10.8-11.856 17.648 0 4.208 1.248 7.696 3.824 10.704 2.704 3.232 6.544 6 11.392 8.352 5.008 2.416 10.208 4.352 15.392 5.728 5.312 1.424 14.224 3.52 26.448 6.24 15.472 3.216 29.696 6.8 42.272 10.672 12.752 3.936 23.712 8.752 32.72 14.384 9.152 5.728 16.4 13.088 21.568 21.904 5.152 8.848 7.76 19.744 7.76 32.416-0.032 15.12-4.512 29.008-13.408 41.072z',
      help:'M256 0c-141.385 0-256 114.615-256 256s114.615 256 256 256 256-114.615 256-256-114.615-256-256-256zM160 256c0-53.020 42.98-96 96-96s96 42.98 96 96-42.98 96-96 96-96-42.98-96-96zM462.99 341.738v0l-88.71-36.745c6.259-15.092 9.72-31.638 9.72-48.993s-3.461-33.901-9.72-48.993l88.71-36.745c10.954 26.411 17.010 55.365 17.010 85.738s-6.057 59.327-17.010 85.738v0zM341.739 49.010v0 0l-36.745 88.71c-15.092-6.259-31.638-9.72-48.994-9.72s-33.901 3.461-48.993 9.72l-36.745-88.711c26.411-10.952 55.366-17.009 85.738-17.009 30.373 0 59.327 6.057 85.739 17.010zM49.010 170.262l88.711 36.745c-6.259 15.092-9.721 31.638-9.721 48.993s3.461 33.901 9.72 48.993l-88.71 36.745c-10.953-26.411-17.010-55.365-17.010-85.738s6.057-59.327 17.010-85.738zM170.262 462.99l36.745-88.71c15.092 6.259 31.638 9.72 48.993 9.72s33.901-3.461 48.993-9.72l36.745 88.71c-26.411 10.952-55.365 17.010-85.738 17.010s-59.327-6.057-85.738-17.010z',
      arrow_down:'M17.23 224q0-56.269 27.73-103.789t75.25-75.25 103.789-27.73 103.789 27.73 75.25 75.25 27.731 103.789-27.731 103.789-75.25 75.25-103.789 27.731-103.789-27.731-75.25-75.25-27.73-103.789zM77.538 224q0 39.846 19.654 73.5t53.308 53.308 73.5 19.654 73.5-19.654 53.308-53.308 19.654-73.5-19.654-73.5-53.308-53.308-73.5-19.654-73.5 19.654-53.308 53.308-19.654 73.5zM129.769 229.385q2.154-5.385 8.077-5.385h51.692v-94.769q0-3.769 2.423-6.192t6.192-2.423h51.692q3.769 0 6.192 2.423t2.423 6.192v94.769h51.692q3.769 0 6.192 2.423t2.423 6.192q0 3.231-2.692 6.461l-85.885 85.885q-2.962 2.423-6.192 2.423t-6.192-2.423l-86.154-86.154q-4.038-4.308-1.885-9.423z',
      task:'M224 397.255l-102.627-118.627 29.254-29.255 73.373 57.372 137.372-121.372 29.256 29.254zM415.886 64c0.039 0.033 0.081 0.075 0.114 0.115v383.771c-0.033 0.039-0.075 0.081-0.114 0.114h-319.772c-0.040-0.033-0.081-0.075-0.114-0.114v-383.772c0.033-0.040 0.075-0.081 0.115-0.114h-64.115v384c0 35.2 28.8 64 64 64h320c35.2 0 64-28.8 64-64v-384h-64.114zM320 64v-32c0-17.673-14.327-32-32-32h-64c-17.673 0-32 14.327-32 32v32h-64v64h256v-64h-64zM288 64h-64v-32h64v32z',
      log:'M512 128l-128-128v96c-65.386 0-115.376 15.604-152.825 47.704-2.625 2.25-5.142 4.55-7.581 6.887 13.76 19.082 24.358 38.758 33.886 57.545 24.161-29.201 59.027-48.136 126.52-48.136v192c-108.223 0-132.563-48.68-163.378-110.311-17.153-34.306-34.89-69.78-67.796-97.985-37.45-32.1-87.44-47.704-152.826-47.704v64c108.223 0 132.563 48.68 163.378 110.311 17.153 34.306 34.89 69.78 67.796 97.985 37.45 32.1 87.441 47.704 152.826 47.704v96l128-128-128-128 128-128zM0 352v64c65.386 0 115.375-15.604 152.825-47.704 2.625-2.249 5.142-4.55 7.581-6.888-13.76-19.081-24.359-38.758-33.886-57.545-24.16 29.201-59.026 48.137-126.52 48.137z',
      work_log:'M289.505 32.086c-121.406 0-220.119 97.266-223.069 218.317h-67.12l100.462 111.984 100.434-111.984h-77.987c2.95-90.139 76.677-162.338 167.281-162.338 92.461 0 167.39 75.175 167.39 167.936s-74.93 167.936-167.39 167.936c-37.083 0-71.325-12.125-99.069-32.577l-38.393 41.070c37.902 29.737 85.607 47.486 137.462 47.486 123.262 0 223.205-100.243 223.205-223.915-0.027-123.672-99.969-223.915-223.205-223.915zM269.654 135.851v128.068l82.057 82.057 27.034-27.034-70.861-70.861v-112.231h-38.23z',
      office:'M0 512h256v-512h-256v512zM160 64h64v64h-64v-64zM160 192h64v64h-64v-64zM160 320h64v64h-64v-64zM32 64h64v64h-64v-64zM32 192h64v64h-64v-64zM32 320h64v64h-64v-64zM288 160h224v32h-224zM288 512h64v-128h96v128h64v-288h-224z',
      _product:'M397.312 183.12c-2.976-4.448-7.968-7.12-13.312-7.12h-16c-8.848 0-16 7.152-16 16v96c0 8.848 7.152 16 16 16h64c8.848 0 16-7.152 16-16v-24c0-3.152-0.944-6.256-2.688-8.88l-48-72zM432 288h-64v-96h16l48 72v24zM503.936 245.376l-64-96c-8.928-13.392-23.872-21.376-39.936-21.376h-64v-32c0-26.464-21.536-48-48-48h-240c-26.464 0-48 21.536-48 48v176c0 26.464 21.536 48 48 48v0 48c0 26.464 21.536 48 48 48h18.272c7.152 27.536 32 48 61.744 48 29.712 0 54.56-20.464 61.712-48h84.512c7.152 27.536 32 48 61.744 48 29.712 0 54.56-20.464 61.712-48h18.304c26.464 0 48-21.536 48-48v-96c0-9.504-2.784-18.72-8.064-26.624zM48 288c-8.832 0-16-7.152-16-16v-176c0-8.848 7.168-16 16-16h240c8.848 0 16 7.152 16 16v176c0 8.848-7.152 16-16 16h-240zM176.016 432c-17.68 0-32-14.336-32-32s14.32-32 32-32c17.664 0 32 14.336 32 32s-14.352 32-32 32zM384 432c-17.68 0-32-14.336-32-32s14.32-32 32-32c17.664 0 32 14.336 32 32s-14.336 32-32 32zM480 368c0 8.848-7.152 16-16 16h-18.288c-7.152-27.536-32-48-61.712-48-29.744 0-54.592 20.464-61.744 48h-84.512c-7.152-27.536-32-48-61.712-48-29.744 0-54.592 20.464-61.744 48h-18.288c-8.832 0-16-7.152-16-16v-48h208c26.464 0 48-21.536 48-48v-112h64c5.344 0 10.336 2.672 13.312 7.12l64 96c1.744 2.624 2.688 5.728 2.688 8.88v96z',
    }

    raise "Icon present in icomoon and iconmonstr" if icomoon[name] && iconmonstr[name]

    view_box = icomoon[name] ? '0 0 512 512' : '45 45 430 430'
    icon = icomoon[name] || iconmonstr[name]

    raise "Icon #{name} not found." unless icon

    # version="1.1" shape-rendering="" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
    %[<svg class="svgicon" id="svgicon-#{name}" style="#{style}" width="#{size}" height="#{size}" viewBox="#{view_box}" xml:space="preserve"><path style="stroke-antialiasing:true;" d="#{icon}"></path></svg>].html_safe
  end

end
