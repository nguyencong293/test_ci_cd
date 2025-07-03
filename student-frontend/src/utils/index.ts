export const formatDate = (date: Date | string): string => {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('vi-VN');
};

export const formatDateTime = (date: Date | string): string => {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleString('vi-VN');
};

export const calculateAge = (birthYear: number): number => {
  const currentYear = new Date().getFullYear();
  return currentYear - birthYear;
};

export const formatScore = (score: number): string => {
  return score.toFixed(1);
};

export const getScoreGrade = (score: number): string => {
  if (score >= 9.0) return 'Xuất sắc';
  if (score >= 8.0) return 'Giỏi';
  if (score >= 6.5) return 'Khá';
  if (score >= 5.0) return 'Trung bình';
  return 'Yếu';
};

export const getScoreColor = (score: number): string => {
  if (score >= 9.0) return 'text-purple-600';
  if (score >= 8.0) return 'text-green-600';
  if (score >= 6.5) return 'text-blue-600';
  if (score >= 5.0) return 'text-yellow-600';
  return 'text-red-600';
};

export const debounce = <T extends (...args: unknown[]) => void>(
  func: T,
  delay: number
): ((...args: Parameters<T>) => void) => {
  let timeoutId: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
};

export const validateStudentId = (id: string): boolean => {
  return /^[A-Z]{1,3}\d{3,4}$/.test(id);
};

export const validateSubjectId = (id: string): boolean => {
  return /^[A-Z]{2}\d{3}$/.test(id);
};

export const validateScore = (score: number): boolean => {
  return score >= 0 && score <= 10;
};

export const generateStudentId = (): string => {
  const prefix = 'SV';
  const number = Math.floor(Math.random() * 9000) + 1000;
  return `${prefix}${number}`;
};

export const generateSubjectId = (): string => {
  const prefix = 'MH';
  const number = Math.floor(Math.random() * 900) + 100;
  return `${prefix}${number}`;
};
