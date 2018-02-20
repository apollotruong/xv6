
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
  int i;

  if(argc < 2){
   6:	bb 01 00 00 00       	mov    $0x1,%ebx
  close(fd);
}

int
main(int argc, char *argv[])
{
   b:	83 e4 f0             	and    $0xfffffff0,%esp
   e:	83 ec 10             	sub    $0x10,%esp
  11:	8b 75 08             	mov    0x8(%ebp),%esi
  14:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
  17:	83 fe 01             	cmp    $0x1,%esi
  1a:	7e 22                	jle    3e <main+0x3e>
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  20:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
  23:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 d2 00 00 00       	call   100 <ls>

  if(argc < 2){
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
  2e:	39 f3                	cmp    %esi,%ebx
  30:	75 ee                	jne    20 <main+0x20>
    ls(argv[i]);
  exit(0);
  32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  39:	e8 74 05 00 00       	call   5b2 <exit>
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
  3e:	c7 04 24 be 0a 00 00 	movl   $0xabe,(%esp)
  45:	e8 b6 00 00 00       	call   100 <ls>
    exit(0);
  4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  51:	e8 5c 05 00 00       	call   5b2 <exit>
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	83 ec 10             	sub    $0x10,%esp
  68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  6b:	89 1c 24             	mov    %ebx,(%esp)
  6e:	e8 9d 03 00 00       	call   410 <strlen>
  73:	01 d8                	add    %ebx,%eax
  75:	73 10                	jae    87 <fmtname+0x27>
  77:	eb 13                	jmp    8c <fmtname+0x2c>
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
    ;
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  8f:	89 1c 24             	mov    %ebx,(%esp)
  92:	e8 79 03 00 00       	call   410 <strlen>
  97:	83 f8 0d             	cmp    $0xd,%eax
  9a:	77 53                	ja     ef <fmtname+0x8f>
    return p;
  memmove(buf, p, strlen(p));
  9c:	89 1c 24             	mov    %ebx,(%esp)
  9f:	e8 6c 03 00 00       	call   410 <strlen>
  a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  a8:	c7 04 24 a8 0d 00 00 	movl   $0xda8,(%esp)
  af:	89 44 24 08          	mov    %eax,0x8(%esp)
  b3:	e8 c8 04 00 00       	call   580 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 50 03 00 00       	call   410 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  c3:	bb a8 0d 00 00       	mov    $0xda8,%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  c8:	89 c6                	mov    %eax,%esi
  ca:	e8 41 03 00 00       	call   410 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	29 f2                	sub    %esi,%edx
  d6:	89 54 24 08          	mov    %edx,0x8(%esp)
  da:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  e1:	00 
  e2:	05 a8 0d 00 00       	add    $0xda8,%eax
  e7:	89 04 24             	mov    %eax,(%esp)
  ea:	e8 51 03 00 00       	call   440 <memset>
  return buf;
}
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	89 d8                	mov    %ebx,%eax
  f4:	5b                   	pop    %ebx
  f5:	5e                   	pop    %esi
  f6:	5d                   	pop    %ebp
  f7:	c3                   	ret    
  f8:	90                   	nop
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000100 <ls>:

void
ls(char *path)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
 10f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 116:	00 
 117:	89 3c 24             	mov    %edi,(%esp)
 11a:	e8 d3 04 00 00       	call   5f2 <open>
 11f:	85 c0                	test   %eax,%eax
 121:	89 c3                	mov    %eax,%ebx
 123:	0f 88 c7 01 00 00    	js     2f0 <ls+0x1f0>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 129:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 12f:	89 74 24 04          	mov    %esi,0x4(%esp)
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 cf 04 00 00       	call   60a <fstat>
 13b:	85 c0                	test   %eax,%eax
 13d:	0f 88 f5 01 00 00    	js     338 <ls+0x238>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 143:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 14a:	66 83 f8 01          	cmp    $0x1,%ax
 14e:	74 68                	je     1b8 <ls+0xb8>
 150:	66 83 f8 02          	cmp    $0x2,%ax
 154:	75 48                	jne    19e <ls+0x9e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 156:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 15c:	89 3c 24             	mov    %edi,(%esp)
 15f:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 165:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 16b:	e8 f0 fe ff ff       	call   60 <fmtname>
 170:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 176:	89 74 24 10          	mov    %esi,0x10(%esp)
 17a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 181:	00 
 182:	c7 44 24 04 9e 0a 00 	movl   $0xa9e,0x4(%esp)
 189:	00 
 18a:	89 54 24 14          	mov    %edx,0x14(%esp)
 18e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 195:	89 44 24 08          	mov    %eax,0x8(%esp)
 199:	e8 72 05 00 00       	call   710 <printf>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 19e:	89 1c 24             	mov    %ebx,(%esp)
 1a1:	e8 34 04 00 00       	call   5da <close>
}
 1a6:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 1ac:	5b                   	pop    %ebx
 1ad:	5e                   	pop    %esi
 1ae:	5f                   	pop    %edi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    
 1b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1b8:	89 3c 24             	mov    %edi,(%esp)
 1bb:	e8 50 02 00 00       	call   410 <strlen>
 1c0:	83 c0 10             	add    $0x10,%eax
 1c3:	3d 00 02 00 00       	cmp    $0x200,%eax
 1c8:	0f 87 4a 01 00 00    	ja     318 <ls+0x218>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 1ce:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1d8:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 aa 01 00 00       	call   390 <strcpy>
    p = buf+strlen(buf);
 1e6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 1c 02 00 00       	call   410 <strlen>
 1f4:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 1fa:	01 c8                	add    %ecx,%eax
    *p++ = '/';
 1fc:	8d 48 01             	lea    0x1(%eax),%ecx
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
 1ff:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 205:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 20b:	c6 00 2f             	movb   $0x2f,(%eax)
 20e:	66 90                	xchg   %ax,%ax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 217:	00 
 218:	89 7c 24 04          	mov    %edi,0x4(%esp)
 21c:	89 1c 24             	mov    %ebx,(%esp)
 21f:	e8 a6 03 00 00       	call   5ca <read>
 224:	83 f8 10             	cmp    $0x10,%eax
 227:	0f 85 71 ff ff ff    	jne    19e <ls+0x9e>
      if(de.inum == 0)
 22d:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 234:	00 
 235:	74 d9                	je     210 <ls+0x110>
        continue;
      memmove(p, de.name, DIRSIZ);
 237:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 23d:	89 44 24 04          	mov    %eax,0x4(%esp)
 241:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
 247:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 24e:	00 
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 29 03 00 00       	call   580 <memmove>
      p[DIRSIZ] = 0;
 257:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 25d:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 261:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 267:	89 74 24 04          	mov    %esi,0x4(%esp)
 26b:	89 04 24             	mov    %eax,(%esp)
 26e:	e8 8d 02 00 00       	call   500 <stat>
 273:	85 c0                	test   %eax,%eax
 275:	0f 88 e5 00 00 00    	js     360 <ls+0x260>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27b:	0f bf 95 d4 fd ff ff 	movswl -0x22c(%ebp),%edx
 282:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 288:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 28e:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 294:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 29a:	89 14 24             	mov    %edx,(%esp)
 29d:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 2a3:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 2a9:	e8 b2 fd ff ff       	call   60 <fmtname>
 2ae:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2b4:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2ba:	c7 44 24 04 9e 0a 00 	movl   $0xa9e,0x4(%esp)
 2c1:	00 
 2c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
 2cd:	8b 8d b4 fd ff ff    	mov    -0x24c(%ebp),%ecx
 2d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
 2d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 2db:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 2df:	e8 2c 04 00 00       	call   710 <printf>
 2e4:	e9 27 ff ff ff       	jmp    210 <ls+0x110>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 2f0:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2f4:	c7 44 24 04 76 0a 00 	movl   $0xa76,0x4(%esp)
 2fb:	00 
 2fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 303:	e8 08 04 00 00       	call   710 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 308:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 30e:	5b                   	pop    %ebx
 30f:	5e                   	pop    %esi
 310:	5f                   	pop    %edi
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	90                   	nop
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 318:	c7 44 24 04 ab 0a 00 	movl   $0xaab,0x4(%esp)
 31f:	00 
 320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 327:	e8 e4 03 00 00       	call   710 <printf>
      break;
 32c:	e9 6d fe ff ff       	jmp    19e <ls+0x9e>
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 338:	89 7c 24 08          	mov    %edi,0x8(%esp)
 33c:	c7 44 24 04 8a 0a 00 	movl   $0xa8a,0x4(%esp)
 343:	00 
 344:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 34b:	e8 c0 03 00 00       	call   710 <printf>
    close(fd);
 350:	89 1c 24             	mov    %ebx,(%esp)
 353:	e8 82 02 00 00       	call   5da <close>
    return;
 358:	e9 49 fe ff ff       	jmp    1a6 <ls+0xa6>
 35d:	8d 76 00             	lea    0x0(%esi),%esi
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 360:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 366:	89 44 24 08          	mov    %eax,0x8(%esp)
 36a:	c7 44 24 04 8a 0a 00 	movl   $0xa8a,0x4(%esp)
 371:	00 
 372:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 379:	e8 92 03 00 00       	call   710 <printf>
        continue;
 37e:	e9 8d fe ff ff       	jmp    210 <ls+0x110>
 383:	66 90                	xchg   %ax,%ax
 385:	66 90                	xchg   %ax,%ax
 387:	66 90                	xchg   %ax,%ax
 389:	66 90                	xchg   %ax,%ax
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 399:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 39a:	89 c2                	mov    %eax,%edx
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a0:	83 c1 01             	add    $0x1,%ecx
 3a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3a7:	83 c2 01             	add    $0x1,%edx
 3aa:	84 db                	test   %bl,%bl
 3ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 3af:	75 ef                	jne    3a0 <strcpy+0x10>
    ;
  return os;
}
 3b1:	5b                   	pop    %ebx
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 55 08             	mov    0x8(%ebp),%edx
 3c6:	53                   	push   %ebx
 3c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3ca:	0f b6 02             	movzbl (%edx),%eax
 3cd:	84 c0                	test   %al,%al
 3cf:	74 2d                	je     3fe <strcmp+0x3e>
 3d1:	0f b6 19             	movzbl (%ecx),%ebx
 3d4:	38 d8                	cmp    %bl,%al
 3d6:	74 0e                	je     3e6 <strcmp+0x26>
 3d8:	eb 2b                	jmp    405 <strcmp+0x45>
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e0:	38 c8                	cmp    %cl,%al
 3e2:	75 15                	jne    3f9 <strcmp+0x39>
    p++, q++;
 3e4:	89 d9                	mov    %ebx,%ecx
 3e6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3e9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3ec:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ef:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 3f3:	84 c0                	test   %al,%al
 3f5:	75 e9                	jne    3e0 <strcmp+0x20>
 3f7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3f9:	29 c8                	sub    %ecx,%eax
}
 3fb:	5b                   	pop    %ebx
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    
 3fe:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 401:	31 c0                	xor    %eax,%eax
 403:	eb f4                	jmp    3f9 <strcmp+0x39>
 405:	0f b6 cb             	movzbl %bl,%ecx
 408:	eb ef                	jmp    3f9 <strcmp+0x39>
 40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000410 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 416:	80 39 00             	cmpb   $0x0,(%ecx)
 419:	74 12                	je     42d <strlen+0x1d>
 41b:	31 d2                	xor    %edx,%edx
 41d:	8d 76 00             	lea    0x0(%esi),%esi
 420:	83 c2 01             	add    $0x1,%edx
 423:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 427:	89 d0                	mov    %edx,%eax
 429:	75 f5                	jne    420 <strlen+0x10>
    ;
  return n;
}
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 42d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	eb 0d                	jmp    440 <memset>
 433:	90                   	nop
 434:	90                   	nop
 435:	90                   	nop
 436:	90                   	nop
 437:	90                   	nop
 438:	90                   	nop
 439:	90                   	nop
 43a:	90                   	nop
 43b:	90                   	nop
 43c:	90                   	nop
 43d:	90                   	nop
 43e:	90                   	nop
 43f:	90                   	nop

00000440 <memset>:

void*
memset(void *dst, int c, uint n)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	8b 55 08             	mov    0x8(%ebp),%edx
 446:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 447:	8b 4d 10             	mov    0x10(%ebp),%ecx
 44a:	8b 45 0c             	mov    0xc(%ebp),%eax
 44d:	89 d7                	mov    %edx,%edi
 44f:	fc                   	cld    
 450:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 452:	89 d0                	mov    %edx,%eax
 454:	5f                   	pop    %edi
 455:	5d                   	pop    %ebp
 456:	c3                   	ret    
 457:	89 f6                	mov    %esi,%esi
 459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <strchr>:

char*
strchr(const char *s, char c)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	53                   	push   %ebx
 467:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 46a:	0f b6 18             	movzbl (%eax),%ebx
 46d:	84 db                	test   %bl,%bl
 46f:	74 1d                	je     48e <strchr+0x2e>
    if(*s == c)
 471:	38 d3                	cmp    %dl,%bl
 473:	89 d1                	mov    %edx,%ecx
 475:	75 0d                	jne    484 <strchr+0x24>
 477:	eb 17                	jmp    490 <strchr+0x30>
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 480:	38 ca                	cmp    %cl,%dl
 482:	74 0c                	je     490 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 484:	83 c0 01             	add    $0x1,%eax
 487:	0f b6 10             	movzbl (%eax),%edx
 48a:	84 d2                	test   %dl,%dl
 48c:	75 f2                	jne    480 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 48e:	31 c0                	xor    %eax,%eax
}
 490:	5b                   	pop    %ebx
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
 493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <gets>:

char*
gets(char *buf, int max)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 4a7:	53                   	push   %ebx
 4a8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4ab:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ae:	eb 31                	jmp    4e1 <gets+0x41>
    cc = read(0, &c, 1);
 4b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b7:	00 
 4b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4c3:	e8 02 01 00 00       	call   5ca <read>
    if(cc < 1)
 4c8:	85 c0                	test   %eax,%eax
 4ca:	7e 1d                	jle    4e9 <gets+0x49>
      break;
    buf[i++] = c;
 4cc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 4d2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 4d5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 4d7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4db:	74 0c                	je     4e9 <gets+0x49>
 4dd:	3c 0a                	cmp    $0xa,%al
 4df:	74 08                	je     4e9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e1:	8d 5e 01             	lea    0x1(%esi),%ebx
 4e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4e7:	7c c7                	jl     4b0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4f0:	83 c4 2c             	add    $0x2c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
 4f8:	90                   	nop
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000500 <stat>:

int
stat(char *n, struct stat *st)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
 505:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 512:	00 
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 d7 00 00 00       	call   5f2 <open>
  if(fd < 0)
 51b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 51d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 51f:	78 27                	js     548 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 521:	8b 45 0c             	mov    0xc(%ebp),%eax
 524:	89 1c 24             	mov    %ebx,(%esp)
 527:	89 44 24 04          	mov    %eax,0x4(%esp)
 52b:	e8 da 00 00 00       	call   60a <fstat>
  close(fd);
 530:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 533:	89 c6                	mov    %eax,%esi
  close(fd);
 535:	e8 a0 00 00 00       	call   5da <close>
  return r;
 53a:	89 f0                	mov    %esi,%eax
}
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
 543:	90                   	nop
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 54d:	eb ed                	jmp    53c <stat+0x3c>
 54f:	90                   	nop

00000550 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	8b 4d 08             	mov    0x8(%ebp),%ecx
 556:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 557:	0f be 11             	movsbl (%ecx),%edx
 55a:	8d 42 d0             	lea    -0x30(%edx),%eax
 55d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 55f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 564:	77 17                	ja     57d <atoi+0x2d>
 566:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 568:	83 c1 01             	add    $0x1,%ecx
 56b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 56e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 572:	0f be 11             	movsbl (%ecx),%edx
 575:	8d 5a d0             	lea    -0x30(%edx),%ebx
 578:	80 fb 09             	cmp    $0x9,%bl
 57b:	76 eb                	jbe    568 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 57d:	5b                   	pop    %ebx
 57e:	5d                   	pop    %ebp
 57f:	c3                   	ret    

00000580 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 580:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 581:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 583:	89 e5                	mov    %esp,%ebp
 585:	56                   	push   %esi
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	53                   	push   %ebx
 58a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 58d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 590:	85 db                	test   %ebx,%ebx
 592:	7e 12                	jle    5a6 <memmove+0x26>
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 598:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 59c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 59f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a2:	39 da                	cmp    %ebx,%edx
 5a4:	75 f2                	jne    598 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 5a6:	5b                   	pop    %ebx
 5a7:	5e                   	pop    %esi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret    

000005aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5aa:	b8 01 00 00 00       	mov    $0x1,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <exit>:
SYSCALL(exit)
 5b2:	b8 02 00 00 00       	mov    $0x2,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <wait>:
SYSCALL(wait)
 5ba:	b8 03 00 00 00       	mov    $0x3,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <pipe>:
SYSCALL(pipe)
 5c2:	b8 04 00 00 00       	mov    $0x4,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <read>:
SYSCALL(read)
 5ca:	b8 05 00 00 00       	mov    $0x5,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <write>:
SYSCALL(write)
 5d2:	b8 10 00 00 00       	mov    $0x10,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <close>:
SYSCALL(close)
 5da:	b8 15 00 00 00       	mov    $0x15,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <kill>:
SYSCALL(kill)
 5e2:	b8 06 00 00 00       	mov    $0x6,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <exec>:
SYSCALL(exec)
 5ea:	b8 07 00 00 00       	mov    $0x7,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <open>:
SYSCALL(open)
 5f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mknod>:
SYSCALL(mknod)
 5fa:	b8 11 00 00 00       	mov    $0x11,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <unlink>:
SYSCALL(unlink)
 602:	b8 12 00 00 00       	mov    $0x12,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <fstat>:
SYSCALL(fstat)
 60a:	b8 08 00 00 00       	mov    $0x8,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <link>:
SYSCALL(link)
 612:	b8 13 00 00 00       	mov    $0x13,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mkdir>:
SYSCALL(mkdir)
 61a:	b8 14 00 00 00       	mov    $0x14,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <chdir>:
SYSCALL(chdir)
 622:	b8 09 00 00 00       	mov    $0x9,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <dup>:
SYSCALL(dup)
 62a:	b8 0a 00 00 00       	mov    $0xa,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <getpid>:
SYSCALL(getpid)
 632:	b8 0b 00 00 00       	mov    $0xb,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <sbrk>:
SYSCALL(sbrk)
 63a:	b8 0c 00 00 00       	mov    $0xc,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <sleep>:
SYSCALL(sleep)
 642:	b8 0d 00 00 00       	mov    $0xd,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <uptime>:
SYSCALL(uptime)
 64a:	b8 0e 00 00 00       	mov    $0xe,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <waitpid>:

SYSCALL(waitpid)
 652:	b8 16 00 00 00       	mov    $0x16,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <setpriority>:
SYSCALL(setpriority)
 65a:	b8 17 00 00 00       	mov    $0x17,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    
 662:	66 90                	xchg   %ax,%ax
 664:	66 90                	xchg   %ax,%ax
 666:	66 90                	xchg   %ax,%ax
 668:	66 90                	xchg   %ax,%ax
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	89 c6                	mov    %eax,%esi
 677:	53                   	push   %ebx
 678:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 67e:	85 db                	test   %ebx,%ebx
 680:	74 09                	je     68b <printint+0x1b>
 682:	89 d0                	mov    %edx,%eax
 684:	c1 e8 1f             	shr    $0x1f,%eax
 687:	84 c0                	test   %al,%al
 689:	75 75                	jne    700 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 68b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 68d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 694:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 697:	31 ff                	xor    %edi,%edi
 699:	89 ce                	mov    %ecx,%esi
 69b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 69e:	eb 02                	jmp    6a2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 6a0:	89 cf                	mov    %ecx,%edi
 6a2:	31 d2                	xor    %edx,%edx
 6a4:	f7 f6                	div    %esi
 6a6:	8d 4f 01             	lea    0x1(%edi),%ecx
 6a9:	0f b6 92 c7 0a 00 00 	movzbl 0xac7(%edx),%edx
  }while((x /= base) != 0);
 6b0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6b2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 6b5:	75 e9                	jne    6a0 <printint+0x30>
  if(neg)
 6b7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6ba:	89 c8                	mov    %ecx,%eax
 6bc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 6bf:	85 d2                	test   %edx,%edx
 6c1:	74 08                	je     6cb <printint+0x5b>
    buf[i++] = '-';
 6c3:	8d 4f 02             	lea    0x2(%edi),%ecx
 6c6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 6cb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 6ce:	66 90                	xchg   %ax,%ax
 6d0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 6d5:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6df:	00 
 6e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 6e4:	89 34 24             	mov    %esi,(%esp)
 6e7:	88 45 d7             	mov    %al,-0x29(%ebp)
 6ea:	e8 e3 fe ff ff       	call   5d2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ef:	83 ff ff             	cmp    $0xffffffff,%edi
 6f2:	75 dc                	jne    6d0 <printint+0x60>
    putc(fd, buf[i]);
}
 6f4:	83 c4 4c             	add    $0x4c,%esp
 6f7:	5b                   	pop    %ebx
 6f8:	5e                   	pop    %esi
 6f9:	5f                   	pop    %edi
 6fa:	5d                   	pop    %ebp
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 700:	89 d0                	mov    %edx,%eax
 702:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 704:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 70b:	eb 87                	jmp    694 <printint+0x24>
 70d:	8d 76 00             	lea    0x0(%esi),%esi

00000710 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 714:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 716:	56                   	push   %esi
 717:	53                   	push   %ebx
 718:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 71e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 721:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 724:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 727:	0f b6 13             	movzbl (%ebx),%edx
 72a:	83 c3 01             	add    $0x1,%ebx
 72d:	84 d2                	test   %dl,%dl
 72f:	75 39                	jne    76a <printf+0x5a>
 731:	e9 c2 00 00 00       	jmp    7f8 <printf+0xe8>
 736:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 738:	83 fa 25             	cmp    $0x25,%edx
 73b:	0f 84 bf 00 00 00    	je     800 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 741:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 744:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 74b:	00 
 74c:	89 44 24 04          	mov    %eax,0x4(%esp)
 750:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 753:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 756:	e8 77 fe ff ff       	call   5d2 <write>
 75b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 75e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 762:	84 d2                	test   %dl,%dl
 764:	0f 84 8e 00 00 00    	je     7f8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 76a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 76c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 76f:	74 c7                	je     738 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 771:	83 ff 25             	cmp    $0x25,%edi
 774:	75 e5                	jne    75b <printf+0x4b>
      if(c == 'd'){
 776:	83 fa 64             	cmp    $0x64,%edx
 779:	0f 84 31 01 00 00    	je     8b0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 77f:	25 f7 00 00 00       	and    $0xf7,%eax
 784:	83 f8 70             	cmp    $0x70,%eax
 787:	0f 84 83 00 00 00    	je     810 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 78d:	83 fa 73             	cmp    $0x73,%edx
 790:	0f 84 a2 00 00 00    	je     838 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 796:	83 fa 63             	cmp    $0x63,%edx
 799:	0f 84 35 01 00 00    	je     8d4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 79f:	83 fa 25             	cmp    $0x25,%edx
 7a2:	0f 84 e0 00 00 00    	je     888 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7a8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7ab:	83 c3 01             	add    $0x1,%ebx
 7ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7b5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7b6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7bc:	89 34 24             	mov    %esi,(%esp)
 7bf:	89 55 d0             	mov    %edx,-0x30(%ebp)
 7c2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 7c6:	e8 07 fe ff ff       	call   5d2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7d8:	00 
 7d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7dd:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7e3:	e8 ea fd ff ff       	call   5d2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7e8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 7ec:	84 d2                	test   %dl,%dl
 7ee:	0f 85 76 ff ff ff    	jne    76a <printf+0x5a>
 7f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7f8:	83 c4 3c             	add    $0x3c,%esp
 7fb:	5b                   	pop    %ebx
 7fc:	5e                   	pop    %esi
 7fd:	5f                   	pop    %edi
 7fe:	5d                   	pop    %ebp
 7ff:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 800:	bf 25 00 00 00       	mov    $0x25,%edi
 805:	e9 51 ff ff ff       	jmp    75b <printf+0x4b>
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 813:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 818:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 81a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 821:	8b 10                	mov    (%eax),%edx
 823:	89 f0                	mov    %esi,%eax
 825:	e8 46 fe ff ff       	call   670 <printint>
        ap++;
 82a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 82e:	e9 28 ff ff ff       	jmp    75b <printf+0x4b>
 833:	90                   	nop
 834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 83b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 83f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 841:	b8 c0 0a 00 00       	mov    $0xac0,%eax
 846:	85 ff                	test   %edi,%edi
 848:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 84b:	0f b6 07             	movzbl (%edi),%eax
 84e:	84 c0                	test   %al,%al
 850:	74 2a                	je     87c <printf+0x16c>
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 858:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 85b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 85e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 861:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 868:	00 
 869:	89 44 24 04          	mov    %eax,0x4(%esp)
 86d:	89 34 24             	mov    %esi,(%esp)
 870:	e8 5d fd ff ff       	call   5d2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 875:	0f b6 07             	movzbl (%edi),%eax
 878:	84 c0                	test   %al,%al
 87a:	75 dc                	jne    858 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 87c:	31 ff                	xor    %edi,%edi
 87e:	e9 d8 fe ff ff       	jmp    75b <printf+0x4b>
 883:	90                   	nop
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 888:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 88b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 88d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 894:	00 
 895:	89 44 24 04          	mov    %eax,0x4(%esp)
 899:	89 34 24             	mov    %esi,(%esp)
 89c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 8a0:	e8 2d fd ff ff       	call   5d2 <write>
 8a5:	e9 b1 fe ff ff       	jmp    75b <printf+0x4b>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8b8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8c2:	8b 10                	mov    (%eax),%edx
 8c4:	89 f0                	mov    %esi,%eax
 8c6:	e8 a5 fd ff ff       	call   670 <printint>
        ap++;
 8cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8cf:	e9 87 fe ff ff       	jmp    75b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8d7:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8d9:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8e2:	00 
 8e3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8e6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f0:	e8 dd fc ff ff       	call   5d2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 8f5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8f9:	e9 5d fe ff ff       	jmp    75b <printf+0x4b>
 8fe:	66 90                	xchg   %ax,%ax

00000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 901:	a1 b8 0d 00 00       	mov    0xdb8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 906:	89 e5                	mov    %esp,%ebp
 908:	57                   	push   %edi
 909:	56                   	push   %esi
 90a:	53                   	push   %ebx
 90b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 910:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 913:	39 d0                	cmp    %edx,%eax
 915:	72 11                	jb     928 <free+0x28>
 917:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	39 c8                	cmp    %ecx,%eax
 91a:	72 04                	jb     920 <free+0x20>
 91c:	39 ca                	cmp    %ecx,%edx
 91e:	72 10                	jb     930 <free+0x30>
 920:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 922:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	73 f0                	jae    918 <free+0x18>
 928:	39 ca                	cmp    %ecx,%edx
 92a:	72 04                	jb     930 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	39 c8                	cmp    %ecx,%eax
 92e:	72 f0                	jb     920 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 930:	8b 73 fc             	mov    -0x4(%ebx),%esi
 933:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 936:	39 cf                	cmp    %ecx,%edi
 938:	74 1e                	je     958 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 93a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 93d:	8b 48 04             	mov    0x4(%eax),%ecx
 940:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 943:	39 f2                	cmp    %esi,%edx
 945:	74 28                	je     96f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 947:	89 10                	mov    %edx,(%eax)
  freep = p;
 949:	a3 b8 0d 00 00       	mov    %eax,0xdb8
}
 94e:	5b                   	pop    %ebx
 94f:	5e                   	pop    %esi
 950:	5f                   	pop    %edi
 951:	5d                   	pop    %ebp
 952:	c3                   	ret    
 953:	90                   	nop
 954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 958:	03 71 04             	add    0x4(%ecx),%esi
 95b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 95e:	8b 08                	mov    (%eax),%ecx
 960:	8b 09                	mov    (%ecx),%ecx
 962:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 965:	8b 48 04             	mov    0x4(%eax),%ecx
 968:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 96b:	39 f2                	cmp    %esi,%edx
 96d:	75 d8                	jne    947 <free+0x47>
    p->s.size += bp->s.size;
 96f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 972:	a3 b8 0d 00 00       	mov    %eax,0xdb8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 977:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 97a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 97d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 97f:	5b                   	pop    %ebx
 980:	5e                   	pop    %esi
 981:	5f                   	pop    %edi
 982:	5d                   	pop    %ebp
 983:	c3                   	ret    
 984:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 98a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000990 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	57                   	push   %edi
 994:	56                   	push   %esi
 995:	53                   	push   %ebx
 996:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 999:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 99c:	8b 1d b8 0d 00 00    	mov    0xdb8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a2:	8d 48 07             	lea    0x7(%eax),%ecx
 9a5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 9a8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9aa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 9ad:	0f 84 9b 00 00 00    	je     a4e <malloc+0xbe>
 9b3:	8b 13                	mov    (%ebx),%edx
 9b5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9b8:	39 fe                	cmp    %edi,%esi
 9ba:	76 64                	jbe    a20 <malloc+0x90>
 9bc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 9c3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 9c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9cb:	eb 0e                	jmp    9db <malloc+0x4b>
 9cd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9d2:	8b 78 04             	mov    0x4(%eax),%edi
 9d5:	39 fe                	cmp    %edi,%esi
 9d7:	76 4f                	jbe    a28 <malloc+0x98>
 9d9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9db:	3b 15 b8 0d 00 00    	cmp    0xdb8,%edx
 9e1:	75 ed                	jne    9d0 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 9e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9e6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9ec:	bf 00 10 00 00       	mov    $0x1000,%edi
 9f1:	0f 43 fe             	cmovae %esi,%edi
 9f4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 9f7:	89 04 24             	mov    %eax,(%esp)
 9fa:	e8 3b fc ff ff       	call   63a <sbrk>
  if(p == (char*)-1)
 9ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 a02:	74 18                	je     a1c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a04:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 a07:	83 c0 08             	add    $0x8,%eax
 a0a:	89 04 24             	mov    %eax,(%esp)
 a0d:	e8 ee fe ff ff       	call   900 <free>
  return freep;
 a12:	8b 15 b8 0d 00 00    	mov    0xdb8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a18:	85 d2                	test   %edx,%edx
 a1a:	75 b4                	jne    9d0 <malloc+0x40>
        return 0;
 a1c:	31 c0                	xor    %eax,%eax
 a1e:	eb 20                	jmp    a40 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a20:	89 d0                	mov    %edx,%eax
 a22:	89 da                	mov    %ebx,%edx
 a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a28:	39 fe                	cmp    %edi,%esi
 a2a:	74 1c                	je     a48 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a2c:	29 f7                	sub    %esi,%edi
 a2e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 a31:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 a34:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 a37:	89 15 b8 0d 00 00    	mov    %edx,0xdb8
      return (void*)(p + 1);
 a3d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a40:	83 c4 1c             	add    $0x1c,%esp
 a43:	5b                   	pop    %ebx
 a44:	5e                   	pop    %esi
 a45:	5f                   	pop    %edi
 a46:	5d                   	pop    %ebp
 a47:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a48:	8b 08                	mov    (%eax),%ecx
 a4a:	89 0a                	mov    %ecx,(%edx)
 a4c:	eb e9                	jmp    a37 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a4e:	c7 05 b8 0d 00 00 bc 	movl   $0xdbc,0xdb8
 a55:	0d 00 00 
    base.s.size = 0;
 a58:	ba bc 0d 00 00       	mov    $0xdbc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a5d:	c7 05 bc 0d 00 00 bc 	movl   $0xdbc,0xdbc
 a64:	0d 00 00 
    base.s.size = 0;
 a67:	c7 05 c0 0d 00 00 00 	movl   $0x0,0xdc0
 a6e:	00 00 00 
 a71:	e9 46 ff ff ff       	jmp    9bc <malloc+0x2c>
