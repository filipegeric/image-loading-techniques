const express = require('express');
const axios = require('axios').default;
const ora = require('ora');
const sharp = require('sharp');
const fs = require('fs').promises;
const { encode } = require('blurhash');

const NUMBER_OF_PHOTOS = 50;

function componentToHex(c) {
  var hex = c.toString(16);
  return hex.length == 1 ? '0' + hex : hex;
}

function rgbToHex(r, g, b) {
  return '#' + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

async function processImage(image) {
  const { data } = await axios.get(image.download_url, {
    responseType: 'arraybuffer',
  });

  const sharpInstance = sharp(data);

  // get dominant color
  const {
    dominant: { r, g, b },
  } = await sharpInstance.stats();
  const color = rgbToHex(r, g, b);

  // generate thumbnail
  const buffer = await sharpInstance
    .resize({ width: 48, kernel: 'mitchell' })
    .webp({ quality: 5, reductionEffort: 6, alphaQuality: 5 })
    .toBuffer();

  // generate blurhash
  const {
    data: blurhashBuffer,
    info,
  } = await sharpInstance
    .raw()
    .ensureAlpha()
    .resize({ width: 32, fit: 'inside' })
    .toBuffer({ resolveWithObject: true });
  const blurhash = encode(blurhashBuffer, info.width, info.height, 4, 4);

  return {
    url: image.download_url,
    width: image.width,
    height: image.height,
    color,
    thumbnail: buffer.toString('base64'),
    blurhash,
  };
}

const spinner = ora();

async function loadImages(forceRefresh) {
  const dir = await fs.readdir(__dirname);
  if (dir.includes('data.json') && !forceRefresh) {
    return;
  }

  spinner.start('Loading images list...');
  const res = await axios.get(
    `https://picsum.photos/v2/list?page=0&limit=${NUMBER_OF_PHOTOS}`,
  );

  spinner.text = 'Generating thumbnails and hashes';
  const result = [];
  for (let i = 0; i < res.data.length; i++) {
    const image = res.data[i];
    result.push(await processImage(image));
  }

  spinner.text = 'Writing data to file...';
  await fs.writeFile('./data.json', JSON.stringify(result));
  spinner.succeed('Images loaded!');
}

async function main() {
  await loadImages();

  const app = express();

  app.get('/data', (_, res) => {
    res.sendFile(__dirname + '/data.json');
  });

  app.listen(3000, () => {
    console.log('App listening on port 3000...');
  });
}

main()
  .catch(console.error)
  .finally(() => {
    if (spinner) {
      spinner.stop();
    }
  });
