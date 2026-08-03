export function toWords(num: number): string {
  const a = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten',
    'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
  ];
  const tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];
  
  if (num === 0) return 'Zero';
  
  const convertDecimal = (n: number) => {
    if (n < 20) return a[n];
    return tens[Math.floor(n / 10)] + (n % 10 !== 0 ? ' ' + a[n % 10] : '');
  };
  
  const convertThreeDigit = (n: number) => {
    let word = '';
    if (n >= 100) {
      word += a[Math.floor(n / 100)] + ' Hundred';
      n %= 100;
      if (n > 0) word += ' and ';
    }
    if (n > 0) {
      word += convertDecimal(n);
    }
    return word;
  };
  
  let str = '';
  let temp = Math.floor(num);
  
  if (temp >= 10000000) {
    str += convertThreeDigit(Math.floor(temp / 10000000)) + ' Crore ';
    temp %= 10000000;
  }
  if (temp >= 100000) {
    str += convertThreeDigit(Math.floor(temp / 100000)) + ' Lakh ';
    temp %= 100000;
  }
  if (temp >= 1000) {
    str += convertThreeDigit(Math.floor(temp / 1000)) + ' Thousand ';
    temp %= 1000;
  }
  if (temp > 0) {
    str += convertThreeDigit(temp);
  }
  
  return 'Rupees: ' + str.trim() + ' Rupees Only';
}
