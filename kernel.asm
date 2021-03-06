
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 2e 10 80       	mov    $0x80102e00,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 6e 10 	movl   $0x80106ec0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 f0 41 00 00       	call   80104250 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 6e 10 	movl   $0x80106ec7,0x4(%esp)
8010009b:	80 
8010009c:	e8 9f 40 00 00       	call   80104140 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 55 42 00 00       	call   80104340 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ca 42 00 00       	call   80104430 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 0f 40 00 00       	call   80104180 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ce 6e 10 80 	movl   $0x80106ece,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 6b 40 00 00       	call   80104220 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 2a 40 00 00       	call   80104220 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 de 3f 00 00       	call   801041e0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 32 41 00 00       	call   80104340 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 db 41 00 00       	jmp    80104430 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 e6 6e 10 80 	movl   $0x80106ee6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 ad 40 00 00       	call   80104340 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 13 34 00 00       	call   801036c0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 08 3a 00 00       	call   80103cd0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 1a 41 00 00       	call   80104430 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 fc 40 00 00       	call   80104430 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 f5 23 00 00       	call   80102770 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ed 6e 10 80 	movl   $0x80106eed,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 3f 78 10 80 	movl   $0x8010783f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 bc 3e 00 00       	call   80104270 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 01 6f 10 80 	movl   $0x80106f01,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 12 56 00 00       	call   80105a20 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 62 55 00 00       	call   80105a20 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 56 55 00 00       	call   80105a20 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 4a 55 00 00       	call   80105a20 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 1f 40 00 00       	call   80104520 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 62 3f 00 00       	call   80104480 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 05 6f 10 80 	movl   $0x80106f05,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 30 6f 10 80 	movzbl -0x7fef90d0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 2d 3d 00 00       	call   80104340 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 f5 3d 00 00       	call   80104430 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 38 3d 00 00       	call   80104430 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 18 6f 10 80       	mov    $0x80106f18,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 a4 3b 00 00       	call   80104340 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 1f 6f 10 80 	movl   $0x80106f1f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 76 3b 00 00       	call   80104340 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 04 3c 00 00       	call   80104430 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 a9 36 00 00       	call   80103f60 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 24 37 00 00       	jmp    80104050 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 28 6f 10 	movl   $0x80106f28,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 e6 38 00 00       	call   80104250 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 0f 2d 00 00       	call   801036c0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 64 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a08:	e8 83 21 00 00       	call   80102b90 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 df 61 00 00       	call   80106c10 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 a9 5f 00 00       	call   80106a80 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 a8 5e 00 00       	call   801069c0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 62 60 00 00       	call   80106b90 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 4b 20 00 00       	call   80102b90 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 0f 5f 00 00       	call   80106a80 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 07 60 00 00       	call   80106b90 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100b93:	e8 f8 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 41 6f 10 80 	movl   $0x80106f41,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 f3 60 00 00       	call   80106cc0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 9a 3a 00 00       	call   801046a0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 89 3a 00 00       	call   801046a0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 ea 61 00 00       	call   80106e20 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 77 61 00 00       	call   80106e20 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 6a 39 00 00       	call   80104660 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 0c 5b 00 00       	call   80106830 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 64 5e 00 00       	call   80106b90 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 4d 6f 10 	movl   $0x80106f4d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 e6 34 00 00       	call   80104250 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 b8 35 00 00       	call   80104340 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 7b 36 00 00       	call   80104430 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 64 36 00 00       	call   80104430 <release>
  return 0;
}
80100dcc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 4a 35 00 00       	call   80104340 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 21 36 00 00       	call   80104430 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e17:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 f8 34 00 00       	call   80104340 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6b:	e9 c0 35 00 00       	jmp    80104430 <release>
    return;
  }
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 9c 35 00 00       	call   80104430 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 b8 23 00 00       	call   80103270 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 5b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 10 09 00 00       	call   801017e0 <iput>
    end_op();
  }
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ed7:	e9 b4 1c 00 00       	jmp    80102b90 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 5c 6f 10 80 	movl   $0x80106f5c,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 24 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 08 00 00       	call   801017a0 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 e7 09 00 00       	call   80101970 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 08 00 00       	call   801017a0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb5:	e9 36 24 00 00       	jmp    801033f0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fc7:	c7 04 24 66 6f 10 80 	movl   $0x80106f66,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 67 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101039:	e8 52 1b 00 00       	call   80102b90 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101063:	e8 b8 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 de 09 00 00       	call   80101a70 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010a4:	e8 e7 1a 00 00       	call   80102b90 <end_op>

      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 1f 22 00 00       	jmp    80103300 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 6f 6f 10 80 	movl   $0x80106f6f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 75 6f 10 80 	movl   $0x80106f75,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 7f 6f 10 80 	movl   $0x80106f7f,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 f7 1a 00 00       	call   80102cc0 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 83 32 00 00       	call   80104480 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 bb 1a 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010123c:	e8 ff 30 00 00       	call   80104340 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 b2 31 00 00       	call   80104430 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 6d 31 00 00       	call   80104430 <release>

  return ip;
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012cd:	c7 04 24 95 6f 10 80 	movl   $0x80106f95,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010132c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 73 19 00 00       	call   80102cc0 <log_write>
    }
    brelse(bp);
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101355:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101358:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101387:	c7 04 24 a5 6f 10 80 	movl   $0x80106fa5,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013c9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 49 31 00 00       	call   80104520 <memmove>
  brelse(bp);
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101433:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101436:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101439:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010143b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 67 18 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
}
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101469:	c7 04 24 b8 6f 10 80 	movl   $0x80106fb8,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 cb 6f 10 	movl   $0x80106fcb,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 b0 2d 00 00       	call   80104250 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 d2 6f 10 	movl   $0x80106fd2,0x4(%esp)
801014b0:	80 
801014b1:	e8 8a 2c 00 00       	call   80104140 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 38 70 10 80 	movl   $0x80107038,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 c2 2e 00 00       	call   80104480 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 ea 16 00 00       	call   80102cc0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015f1:	c7 04 24 d8 6f 10 80 	movl   $0x80106fd8,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 ab 2e 00 00       	call   80104520 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 43 16 00 00       	call   80102cc0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 9a 2c 00 00       	call   80104340 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 7a 2d 00 00       	call   80104430 <release>
  return ip;
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 97 2a 00 00       	call   80104180 <acquiresleep>

  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 c0 2d 00 00       	call   80104520 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 f0 6f 10 80 	movl   $0x80106ff0,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101786:	c7 04 24 ea 6f 10 80 	movl   $0x80106fea,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 66 2a 00 00       	call   80104220 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ce:	e9 0d 2a 00 00       	jmp    801041e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017d3:	c7 04 24 ff 6f 10 80 	movl   $0x80106fff,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 89 29 00 00       	call   80104180 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 d3 29 00 00       	call   801041e0 <releasesleep>

  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 27 2b 00 00       	call   80104340 <acquire>
  ip->ref--;
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010182b:	e9 00 2c 00 00       	jmp    80104430 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 04 2b 00 00       	call   80104340 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 e5 2b 00 00       	call   80104430 <release>
    if(r == 1){
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 7b fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018be:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
      if(a[j])
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 fd fa ff ff       	call   801013f0 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
    }
    brelse(bp);
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 e0 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 09 f9 ff ff       	call   801012e0 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019fe:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 03 2b 00 00       	call   80104520 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 04 f8 ff ff       	call   801012e0 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b07:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 07 2a 00 00       	call   80104520 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 9f 11 00 00       	call   80102cc0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
  }
  return n;
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 e0 29 00 00       	call   801045a0 <strncmp>
}
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 62 29 00 00       	call   801045a0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
        *poff = off;
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 c7 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c6b:	31 c0                	xor    %eax,%eax
}
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c72:	c7 04 24 19 70 10 80 	movl   $0x80107019,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 07 70 10 80 	movl   $0x80107007,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 12 1a 00 00       	call   801036c0 <myproc>
80101cae:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 83 26 00 00       	call   80104340 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 63 27 00 00       	call   80104430 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
    path++;
  if(*path == 0)
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
    path++;
80101d02:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 f0 27 00 00       	call   80104520 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d5e:	85 d2                	test   %edx,%edx
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 62 27 00 00       	call   80104520 <memmove>
    name[len] = 0;
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101df3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 17 f4 ff ff       	call   80101220 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e1b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 c0                	test   %eax,%eax
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 58 27 00 00       	call   80104610 <strncpy>
  de.inum = inum;
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101edc:	31 c0                	xor    %eax,%eax
}
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
    return -1;
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ef5:	c7 04 24 28 70 10 80 	movl   $0x80107028,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f01:	c7 04 24 26 76 10 80 	movl   $0x80107626,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	53                   	push   %ebx
80101f57:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 99 00 00 00    	je     80101ffb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f62:	8b 48 08             	mov    0x8(%eax),%ecx
80101f65:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6b:	0f 87 7e 00 00 00    	ja     80101fef <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f80:	31 db                	xor    %ebx,%ebx
80101f82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f94:	ee                   	out    %al,(%dx)
80101f95:	0f b6 c1             	movzbl %cl,%eax
80101f98:	b2 f3                	mov    $0xf3,%dl
80101f9a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f9b:	89 c8                	mov    %ecx,%eax
80101f9d:	b2 f4                	mov    $0xf4,%dl
80101f9f:	c1 f8 08             	sar    $0x8,%eax
80101fa2:	ee                   	out    %al,(%dx)
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	89 d8                	mov    %ebx,%eax
80101fa7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fa8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fac:	b2 f6                	mov    $0xf6,%dl
80101fae:	83 e0 01             	and    $0x1,%eax
80101fb1:	c1 e0 04             	shl    $0x4,%eax
80101fb4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fb8:	f6 06 04             	testb  $0x4,(%esi)
80101fbb:	75 13                	jne    80101fd0 <idestart+0x80>
80101fbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fef:	c7 04 24 94 70 10 80 	movl   $0x80107094,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101ffb:	c7 04 24 8b 70 10 80 	movl   $0x8010708b,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102016:	c7 44 24 04 a6 70 10 	movl   $0x801070a6,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 26 22 00 00       	call   80104250 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
      havedisk1 = 1;
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 9b 22 00 00       	call   80104340 <acquire>

  if((b = idequeue) == 0){
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 8f 1e 00 00       	call   80103f60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 45 23 00 00       	call   80104430 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 db 20 00 00       	call   80104220 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 c5 21 00 00       	call   80104340 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010219c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
    sleep(b, &idelock);
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 10 1b 00 00       	call   80103cd0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021d6:	e9 55 22 00 00       	jmp    80104430 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021eb:	c7 04 24 aa 70 10 80 	movl   $0x801070aa,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 d5 70 10 80 	movl   $0x801070d5,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102203:	c7 04 24 c0 70 10 80 	movl   $0x801070c0,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
8010220f:	90                   	nop

80102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
  return ioapic->data;
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102251:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102258:	c7 04 24 f4 70 10 80 	movl   $0x801070f4,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102297:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010229f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022da:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022e8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	66 90                	xchg   %ax,%ax
801022f8:	66 90                	xchg   %ax,%ax
801022fa:	66 90                	xchg   %ax,%ax
801022fc:	66 90                	xchg   %ax,%ax
801022fe:	66 90                	xchg   %ax,%ax

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 41 21 00 00       	call   80104480 <memset>

  if(kmem.use_lock)
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
    release(&kmem.lock);
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102374:	e9 b7 20 00 00       	jmp    80104430 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 b4 1f 00 00       	call   80104340 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010238e:	c7 04 24 26 71 10 80 	movl   $0x80107126,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
    kfree(p);
}
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023fb:	c7 44 24 04 2c 71 10 	movl   $0x8010712c,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 41 1e 00 00       	call   80104250 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
}
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
    release(&kmem.lock);
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 4e 1f 00 00       	call   80104430 <release>
  return (char*)r;
}
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 44 1e 00 00       	call   80104340 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102521:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102544:	0f b6 81 60 72 10 80 	movzbl -0x7fef8da0(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102575:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102578:	0f b6 91 60 72 10 80 	movzbl -0x7fef8da0(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 60 71 10 80 	movzbl -0x7fef8ea0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 40 71 10 80 	mov    -0x7fef8ec0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	53                   	push   %ebx
8010260b:	31 c0                	xor    %eax,%eax
8010260d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102616:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 01                	mov    %eax,(%ecx)
8010261d:	b8 02 00 00 00       	mov    $0x2,%eax
80102622:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
80102626:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 41 04             	mov    %eax,0x4(%ecx)
8010262e:	b8 04 00 00 00       	mov    $0x4,%eax
80102633:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102634:	89 da                	mov    %ebx,%edx
80102636:	ec                   	in     (%dx),%al
80102637:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263a:	b2 70                	mov    $0x70,%dl
8010263c:	89 41 08             	mov    %eax,0x8(%ecx)
8010263f:	b8 07 00 00 00       	mov    $0x7,%eax
80102644:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102645:	89 da                	mov    %ebx,%edx
80102647:	ec                   	in     (%dx),%al
80102648:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264b:	b2 70                	mov    $0x70,%dl
8010264d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102650:	b8 08 00 00 00       	mov    $0x8,%eax
80102655:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102656:	89 da                	mov    %ebx,%edx
80102658:	ec                   	in     (%dx),%al
80102659:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265c:	b2 70                	mov    $0x70,%dl
8010265e:	89 41 10             	mov    %eax,0x10(%ecx)
80102661:	b8 09 00 00 00       	mov    $0x9,%eax
80102666:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102667:	89 da                	mov    %ebx,%edx
80102669:	ec                   	in     (%dx),%al
8010266a:	0f b6 d8             	movzbl %al,%ebx
8010266d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102670:	5b                   	pop    %ebx
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102680:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102788:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	89 e5                	mov    %esp,%ebp
801027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	b2 71                	mov    $0x71,%dl
801027dc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027dd:	31 c0                	xor    %eax,%eax
801027df:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027e5:	89 d8                	mov    %ebx,%eax
801027e7:	c1 e8 04             	shr    $0x4,%eax
801027ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027f5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102801:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102804:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010280b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102811:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102818:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102827:	89 da                	mov    %ebx,%edx
80102829:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102835:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102847:	5b                   	pop    %ebx
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	89 e5                	mov    %esp,%ebp
80102858:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	b2 71                	mov    $0x71,%dl
80102866:	ec                   	in     (%dx),%al
80102867:	88 45 b7             	mov    %al,-0x49(%ebp)
8010286a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010286d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102871:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010287d:	89 d8                	mov    %ebx,%eax
8010287f:	e8 7c fd ff ff       	call   80102600 <fill_rtcdate>
80102884:	b8 0a 00 00 00       	mov    $0xa,%eax
80102889:	89 f2                	mov    %esi,%edx
8010288b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	ba 71 00 00 00       	mov    $0x71,%edx
80102891:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102892:	84 c0                	test   %al,%al
80102894:	78 e7                	js     8010287d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102896:	89 f8                	mov    %edi,%eax
80102898:	e8 63 fd ff ff       	call   80102600 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028a4:	00 
801028a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028a9:	89 1c 24             	mov    %ebx,(%esp)
801028ac:	e8 1f 1c 00 00       	call   801044d0 <memcmp>
801028b1:	85 c0                	test   %eax,%eax
801028b3:	75 c3                	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028b5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b9:	75 78                	jne    80102933 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028be:	89 c2                	mov    %eax,%edx
801028c0:	83 e0 0f             	and    $0xf,%eax
801028c3:	c1 ea 04             	shr    $0x4,%edx
801028c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	83 e0 0f             	and    $0xf,%eax
801028d7:	c1 ea 04             	shr    $0x4,%edx
801028da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e6:	89 c2                	mov    %eax,%edx
801028e8:	83 e0 0f             	and    $0xf,%eax
801028eb:	c1 ea 04             	shr    $0x4,%edx
801028ee:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	83 e0 0f             	and    $0xf,%eax
801028ff:	c1 ea 04             	shr    $0x4,%edx
80102902:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102905:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102933:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102936:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102939:	89 01                	mov    %eax,(%ecx)
8010293b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293e:	89 41 04             	mov    %eax,0x4(%ecx)
80102941:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102944:	89 41 08             	mov    %eax,0x8(%ecx)
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010294d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102950:	89 41 10             	mov    %eax,0x10(%ecx)
80102953:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102956:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102959:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102960:	83 c4 4c             	add    $0x4c,%esp
80102963:	5b                   	pop    %ebx
80102964:	5e                   	pop    %esi
80102965:	5f                   	pop    %edi
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102976:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102978:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010297b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	7e 78                	jle    801029fc <install_trans+0x8c>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102988:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010298d:	01 d8                	add    %ebx,%eax
8010298f:	83 c0 01             	add    $0x1,%eax
80102992:	89 44 24 04          	mov    %eax,0x4(%esp)
80102996:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010299b:	89 04 24             	mov    %eax,(%esp)
8010299e:	e8 2d d7 ff ff       	call   801000d0 <bread>
801029a3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029af:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029b8:	89 04 24             	mov    %eax,(%esp)
801029bb:	e8 10 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029c7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ca:	8d 47 5c             	lea    0x5c(%edi),%eax
801029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d4:	89 04 24             	mov    %eax,(%esp)
801029d7:	e8 44 1b 00 00       	call   80104520 <memmove>
    bwrite(dbuf);  // write dst to disk
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 bc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e4:	89 3c 24             	mov    %edi,(%esp)
801029e7:	e8 f4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ec d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 8c                	jg     80102988 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029fc:	83 c4 1c             	add    $0x1c,%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    
80102a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a19:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a22:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a27:	89 04 24             	mov    %eax,(%esp)
80102a2a:	e8 a1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a35:	31 d2                	xor    %edx,%edx
80102a37:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a39:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a3e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a41:	7e 17                	jle    80102a5a <write_head+0x4a>
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a53:	83 c2 01             	add    $0x1,%edx
80102a56:	39 da                	cmp    %ebx,%edx
80102a58:	75 ee                	jne    80102a48 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a5a:	89 3c 24             	mov    %edi,(%esp)
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 3c 24             	mov    %edi,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	83 c4 1c             	add    $0x1c,%esp
80102a6d:	5b                   	pop    %ebx
80102a6e:	5e                   	pop    %esi
80102a6f:	5f                   	pop    %edi
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	83 ec 30             	sub    $0x30,%esp
80102a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a8b:	c7 44 24 04 60 73 10 	movl   $0x80107360,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 b1 17 00 00       	call   80104250 <initlock>
  readsb(dev, &sb);
80102a9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa6:	89 1c 24             	mov    %ebx,(%esp)
80102aa9:	e8 f2 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ab1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ab4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102ab7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102abd:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac7:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acc:	e8 ff d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ad3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ad6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102adb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <initlog+0x7a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ae8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aec:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102afa:	89 04 24             	mov    %eax,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b02:	e8 69 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102b07:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b0e:	00 00 00 
  write_head(); // clear the log
80102b11:	e8 fa fe ff ff       	call   80102a10 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b16:	83 c4 30             	add    $0x30,%esp
80102b19:	5b                   	pop    %ebx
80102b1a:	5e                   	pop    %esi
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b2d:	e8 0e 18 00 00       	call   80104340 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 84 11 00 00       	call   80103cd0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b4c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 e3                	jne    80102b38 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b66:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b69:	83 fa 1e             	cmp    $0x1e,%edx
80102b6c:	7f ca                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b7a:	e8 b1 18 00 00       	call   80104430 <release>
      break;
    }
  }
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    
80102b81:	eb 0d                	jmp    80102b90 <end_op>
80102b83:	90                   	nop
80102b84:	90                   	nop
80102b85:	90                   	nop
80102b86:	90                   	nop
80102b87:	90                   	nop
80102b88:	90                   	nop
80102b89:	90                   	nop
80102b8a:	90                   	nop
80102b8b:	90                   	nop
80102b8c:	90                   	nop
80102b8d:	90                   	nop
80102b8e:	90                   	nop
80102b8f:	90                   	nop

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ba0:	e8 9b 17 00 00       	call   80104340 <acquire>
  log.outstanding -= 1;
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102baa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bb0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bba:	0f 85 f3 00 00 00    	jne    80102cb3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	0f 85 cb 00 00 00    	jne    80102c93 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bcf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bd1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bdb:	e8 50 18 00 00       	call   80104430 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102be0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	0f 8e 90 00 00 00    	jle    80102c7d <end_op+0xed>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	01 d8                	add    %ebx,%eax
80102bf7:	83 c0 01             	add    $0x1,%eax
80102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c03:	89 04 24             	mov    %eax,(%esp)
80102c06:	e8 c5 d4 ff ff       	call   801000d0 <bread>
80102c0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c0d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c20:	89 04 24             	mov    %eax,(%esp)
80102c23:	e8 a8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c2f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c30:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c32:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c39:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3c:	89 04 24             	mov    %eax,(%esp)
80102c3f:	e8 dc 18 00 00       	call   80104520 <memmove>
    bwrite(to);  // write the log
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 54 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c4c:	89 3c 24             	mov    %edi,(%esp)
80102c4f:	e8 8c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 84 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 8c                	jl     80102bf0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 a7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 02 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 93 fd ff ff       	call   80102a10 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c84:	e8 b7 16 00 00       	call   80104340 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 c1 12 00 00       	call   80103f60 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 85 17 00 00       	call   80104430 <release>
  }
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102cb3:	c7 04 24 64 73 10 80 	movl   $0x80107364,(%esp)
80102cba:	e8 a1 d6 ff ff       	call   80100360 <panic>
80102cbf:	90                   	nop

80102cc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cc7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ccf:	83 f8 1d             	cmp    $0x1d,%eax
80102cd2:	0f 8f 98 00 00 00    	jg     80102d70 <log_write+0xb0>
80102cd8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cde:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ce1:	39 d0                	cmp    %edx,%eax
80102ce3:	0f 8d 87 00 00 00    	jge    80102d70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ce9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	0f 8e 86 00 00 00    	jle    80102d7c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cf6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cfd:	e8 3e 16 00 00       	call   80104340 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d02:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d08:	83 fa 00             	cmp    $0x0,%edx
80102d0b:	7e 54                	jle    80102d61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d0d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d10:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d12:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d18:	75 0f                	jne    80102d29 <log_write+0x69>
80102d1a:	eb 3c                	jmp    80102d58 <log_write+0x98>
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d20:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d27:	74 2f                	je     80102d58 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c0 01             	add    $0x1,%eax
80102d2c:	39 d0                	cmp    %edx,%eax
80102d2e:	75 f0                	jne    80102d20 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d30:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d37:	83 c2 01             	add    $0x1,%edx
80102d3a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d43:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d4a:	83 c4 14             	add    $0x14,%esp
80102d4d:	5b                   	pop    %ebx
80102d4e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d4f:	e9 dc 16 00 00       	jmp    80104430 <release>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d58:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d5f:	eb df                	jmp    80102d40 <log_write+0x80>
80102d61:	8b 43 08             	mov    0x8(%ebx),%eax
80102d64:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d69:	75 d5                	jne    80102d40 <log_write+0x80>
80102d6b:	eb ca                	jmp    80102d37 <log_write+0x77>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d70:	c7 04 24 73 73 10 80 	movl   $0x80107373,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d7c:	c7 04 24 89 73 10 80 	movl   $0x80107389,(%esp)
80102d83:	e8 d8 d5 ff ff       	call   80100360 <panic>
80102d88:	66 90                	xchg   %ax,%ax
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d97:	e8 04 09 00 00       	call   801036a0 <cpuid>
80102d9c:	89 c3                	mov    %eax,%ebx
80102d9e:	e8 fd 08 00 00       	call   801036a0 <cpuid>
80102da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102da7:	c7 04 24 a4 73 10 80 	movl   $0x801073a4,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 84 29 00 00       	call   80105740 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dbc:	e8 5f 08 00 00       	call   80103620 <mycpu>
80102dc1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dc8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dcf:	e8 bc 0b 00 00       	call   80103990 <scheduler>
80102dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102de0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102de6:	e8 25 3a 00 00       	call   80106810 <switchkvm>
  seginit();
80102deb:	e8 60 39 00 00       	call   80106750 <seginit>
  lapicinit();
80102df0:	e8 8b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102df5:	e8 96 ff ff ff       	call   80102d90 <mpmain>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e04:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e09:	83 e4 f0             	and    $0xfffffff0,%esp
80102e0c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e0f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e16:	80 
80102e17:	c7 04 24 a8 58 11 80 	movl   $0x801158a8,(%esp)
80102e1e:	e8 cd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e23:	e8 78 3e 00 00       	call   80106ca0 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 16 39 00 00       	call   80106750 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 21 2c 00 00       	call   80105a70 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 ab 07 00 00       	call   80103600 <pinit>
  tvinit();        // trap vectors
80102e55:	e8 46 28 00 00       	call   801056a0 <tvinit>
  binit();         // buffer cache
80102e5a:	e8 e1 d1 ff ff       	call   80100040 <binit>
80102e5f:	90                   	nop
  fileinit();      // file table
80102e60:	e8 eb de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e65:	e8 a6 f1 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e6a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e71:	00 
80102e72:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e79:	80 
80102e7a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e81:	e8 9a 16 00 00       	call   80104520 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e86:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e8d:	00 00 00 
80102e90:	05 80 27 11 80       	add    $0x80112780,%eax
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	76 6a                	jbe    80102f03 <main+0x103>
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ea0:	e8 7b 07 00 00       	call   80103620 <mycpu>
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	74 41                	je     80102eea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ea9:	e8 02 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102eae:	c7 05 f8 6f 00 80 e0 	movl   $0x80102de0,0x80006ff8
80102eb5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eb8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ebf:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ec2:	05 00 10 00 00       	add    $0x1000,%eax
80102ec7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ecc:	0f b6 03             	movzbl (%ebx),%eax
80102ecf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ed6:	00 
80102ed7:	89 04 24             	mov    %eax,(%esp)
80102eda:	e8 e1 f8 ff ff       	call   801027c0 <lapicstartap>
80102edf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ee0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 f6                	je     80102ee0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef1:	00 00 00 
80102ef4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102efa:	05 80 27 11 80       	add    $0x80112780,%eax
80102eff:	39 c3                	cmp    %eax,%ebx
80102f01:	72 9d                	jb     80102ea0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f03:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f0a:	8e 
80102f0b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f12:	e8 49 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f17:	e8 d4 07 00 00       	call   801036f0 <userinit>
  mpmain();        // finish this processor's setup
80102f1c:	e8 6f fe ff ff       	call   80102d90 <mpmain>
80102f21:	66 90                	xchg   %ax,%ax
80102f23:	66 90                	xchg   %ax,%ax
80102f25:	66 90                	xchg   %ax,%ax
80102f27:	66 90                	xchg   %ax,%ax
80102f29:	66 90                	xchg   %ax,%ax
80102f2b:	66 90                	xchg   %ax,%ax
80102f2d:	66 90                	xchg   %ax,%ax
80102f2f:	90                   	nop

80102f30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f34:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f3a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f3b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f3e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f41:	39 de                	cmp    %ebx,%esi
80102f43:	73 3c                	jae    80102f81 <mpsearch1+0x51>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f48:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f4f:	00 
80102f50:	c7 44 24 04 b8 73 10 	movl   $0x801073b8,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 70 15 00 00       	call   801044d0 <memcmp>
80102f60:	85 c0                	test   %eax,%eax
80102f62:	75 16                	jne    80102f7a <mpsearch1+0x4a>
80102f64:	31 c9                	xor    %ecx,%ecx
80102f66:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f68:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f6c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f6f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f71:	83 fa 10             	cmp    $0x10,%edx
80102f74:	75 f2                	jne    80102f68 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f76:	84 c9                	test   %cl,%cl
80102f78:	74 10                	je     80102f8a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7a:	83 c6 10             	add    $0x10,%esi
80102f7d:	39 f3                	cmp    %esi,%ebx
80102f7f:	77 c7                	ja     80102f48 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f81:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f84:	31 c0                	xor    %eax,%eax
}
80102f86:	5b                   	pop    %ebx
80102f87:	5e                   	pop    %esi
80102f88:	5d                   	pop    %ebp
80102f89:	c3                   	ret    
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	89 f0                	mov    %esi,%eax
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5d                   	pop    %ebp
80102f92:	c3                   	ret    
80102f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fb7:	c1 e0 08             	shl    $0x8,%eax
80102fba:	09 d0                	or     %edx,%eax
80102fbc:	c1 e0 04             	shl    $0x4,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 1b                	jne    80102fde <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fc3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fd1:	c1 e0 08             	shl    $0x8,%eax
80102fd4:	09 d0                	or     %edx,%eax
80102fd6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fd9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fde:	ba 00 04 00 00       	mov    $0x400,%edx
80102fe3:	e8 48 ff ff ff       	call   80102f30 <mpsearch1>
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	89 c7                	mov    %eax,%edi
80102fec:	0f 84 22 01 00 00    	je     80103114 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ff2:	8b 77 04             	mov    0x4(%edi),%esi
80102ff5:	85 f6                	test   %esi,%esi
80102ff7:	0f 84 30 01 00 00    	je     8010312d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ffd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103003:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300a:	00 
8010300b:	c7 44 24 04 bd 73 10 	movl   $0x801073bd,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 b2 14 00 00       	call   801044d0 <memcmp>
8010301e:	85 c0                	test   %eax,%eax
80103020:	0f 85 07 01 00 00    	jne    8010312d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103026:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010302d:	3c 04                	cmp    $0x4,%al
8010302f:	0f 85 0b 01 00 00    	jne    80103140 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103035:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 21                	je     80103061 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103040:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103042:	31 d2                	xor    %edx,%edx
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103048:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010304f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103050:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103053:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103055:	39 d0                	cmp    %edx,%eax
80103057:	7f ef                	jg     80103048 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103059:	84 c9                	test   %cl,%cl
8010305b:	0f 85 cc 00 00 00    	jne    8010312d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103064:	85 c0                	test   %eax,%eax
80103066:	0f 84 c1 00 00 00    	je     8010312d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010306c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103072:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103077:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103083:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103089:	03 55 e4             	add    -0x1c(%ebp),%edx
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 c2                	cmp    %eax,%edx
80103092:	76 1b                	jbe    801030af <mpinit+0x10f>
80103094:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103097:	80 f9 04             	cmp    $0x4,%cl
8010309a:	77 74                	ja     80103110 <mpinit+0x170>
8010309c:	ff 24 8d fc 73 10 80 	jmp    *-0x7fef8c04(,%ecx,4)
801030a3:	90                   	nop
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030a8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ab:	39 c2                	cmp    %eax,%edx
801030ad:	77 e5                	ja     80103094 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030af:	85 db                	test   %ebx,%ebx
801030b1:	0f 84 93 00 00 00    	je     8010314a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030b7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030bb:	74 12                	je     801030cf <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bd:	ba 22 00 00 00       	mov    $0x22,%edx
801030c2:	b8 70 00 00 00       	mov    $0x70,%eax
801030c7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c8:	b2 23                	mov    $0x23,%dl
801030ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030cb:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ce:	ee                   	out    %al,(%dx)
  }
}
801030cf:	83 c4 1c             	add    $0x1c,%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030d8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030de:	83 fe 07             	cmp    $0x7,%esi
801030e1:	7f 17                	jg     801030fa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030e7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ed:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801030fa:	83 c0 14             	add    $0x14,%eax
      continue;
801030fd:	eb 91                	jmp    80103090 <mpinit+0xf0>
801030ff:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103100:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103104:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103107:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
8010310d:	eb 81                	jmp    80103090 <mpinit+0xf0>
8010310f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103110:	31 db                	xor    %ebx,%ebx
80103112:	eb 83                	jmp    80103097 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103114:	ba 00 00 01 00       	mov    $0x10000,%edx
80103119:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010311e:	e8 0d fe ff ff       	call   80102f30 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103125:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103127:	0f 85 c5 fe ff ff    	jne    80102ff2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010312d:	c7 04 24 c2 73 10 80 	movl   $0x801073c2,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
80103151:	e8 0a d2 ff ff       	call   80100360 <panic>
80103156:	66 90                	xchg   %ax,%ax
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103160:	55                   	push   %ebp
80103161:	ba 21 00 00 00       	mov    $0x21,%edx
80103166:	89 e5                	mov    %esp,%ebp
80103168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010316d:	ee                   	out    %al,(%dx)
8010316e:	b2 a1                	mov    $0xa1,%dl
80103170:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	66 90                	xchg   %ax,%ax
80103175:	66 90                	xchg   %ax,%ax
80103177:	66 90                	xchg   %ax,%ax
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
80103189:	8b 75 08             	mov    0x8(%ebp),%esi
8010318c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010318f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010319b:	e8 d0 db ff ff       	call   80100d70 <filealloc>
801031a0:	85 c0                	test   %eax,%eax
801031a2:	89 06                	mov    %eax,(%esi)
801031a4:	0f 84 a4 00 00 00    	je     8010324e <pipealloc+0xce>
801031aa:	e8 c1 db ff ff       	call   80100d70 <filealloc>
801031af:	85 c0                	test   %eax,%eax
801031b1:	89 03                	mov    %eax,(%ebx)
801031b3:	0f 84 87 00 00 00    	je     80103240 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031b9:	e8 f2 f2 ff ff       	call   801024b0 <kalloc>
801031be:	85 c0                	test   %eax,%eax
801031c0:	89 c7                	mov    %eax,%edi
801031c2:	74 7c                	je     80103240 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031cb:	00 00 00 
  p->writeopen = 1;
801031ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031d5:	00 00 00 
  p->nwrite = 0;
801031d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031df:	00 00 00 
  p->nread = 0;
801031e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031e9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ec:	89 04 24             	mov    %eax,(%esp)
801031ef:	c7 44 24 04 10 74 10 	movl   $0x80107410,0x4(%esp)
801031f6:	80 
801031f7:	e8 54 10 00 00       	call   80104250 <initlock>
  (*f0)->type = FD_PIPE;
801031fc:	8b 06                	mov    (%esi),%eax
801031fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103204:	8b 06                	mov    (%esi),%eax
80103206:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010320a:	8b 06                	mov    (%esi),%eax
8010320c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103210:	8b 06                	mov    (%esi),%eax
80103212:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103215:	8b 03                	mov    (%ebx),%eax
80103217:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010321d:	8b 03                	mov    (%ebx),%eax
8010321f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103223:	8b 03                	mov    (%ebx),%eax
80103225:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103229:	8b 03                	mov    (%ebx),%eax
  return 0;
8010322b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010322d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103230:	83 c4 1c             	add    $0x1c,%esp
80103233:	89 d8                	mov    %ebx,%eax
80103235:	5b                   	pop    %ebx
80103236:	5e                   	pop    %esi
80103237:	5f                   	pop    %edi
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103240:	8b 06                	mov    (%esi),%eax
80103242:	85 c0                	test   %eax,%eax
80103244:	74 08                	je     8010324e <pipealloc+0xce>
    fileclose(*f0);
80103246:	89 04 24             	mov    %eax,(%esp)
80103249:	e8 e2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010324e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103250:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103255:	85 c0                	test   %eax,%eax
80103257:	74 d7                	je     80103230 <pipealloc+0xb0>
    fileclose(*f1);
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 cf db ff ff       	call   80100e30 <fileclose>
  return -1;
}
80103261:	83 c4 1c             	add    $0x1c,%esp
80103264:	89 d8                	mov    %ebx,%eax
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
80103278:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010327e:	89 1c 24             	mov    %ebx,(%esp)
80103281:	e8 ba 10 00 00       	call   80104340 <acquire>
  if(writable){
80103286:	85 f6                	test   %esi,%esi
80103288:	74 3e                	je     801032c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010328a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103290:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103297:	00 00 00 
    wakeup(&p->nread);
8010329a:	89 04 24             	mov    %eax,(%esp)
8010329d:	e8 be 0c 00 00       	call   80103f60 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032a8:	85 d2                	test   %edx,%edx
801032aa:	75 0a                	jne    801032b6 <pipeclose+0x46>
801032ac:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 32                	je     801032e8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032bf:	e9 6c 11 00 00       	jmp    80104430 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 80 0c 00 00       	call   80103f60 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 40 11 00 00       	call   80104430 <release>
    kfree((char*)p);
801032f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032f9:	e9 02 f0 ff ff       	jmp    80102300 <kfree>
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010330c:	89 1c 24             	mov    %ebx,(%esp)
8010330f:	e8 2c 10 00 00       	call   80104340 <acquire>
  for(i = 0; i < n; i++){
80103314:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103317:	85 c9                	test   %ecx,%ecx
80103319:	0f 8e b2 00 00 00    	jle    801033d1 <pipewrite+0xd1>
8010331f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103322:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103328:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010332e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103334:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103337:	03 4d 10             	add    0x10(%ebp),%ecx
8010333a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010333d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103343:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103349:	39 c8                	cmp    %ecx,%eax
8010334b:	74 38                	je     80103385 <pipewrite+0x85>
8010334d:	eb 55                	jmp    801033a4 <pipewrite+0xa4>
8010334f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103350:	e8 6b 03 00 00       	call   801036c0 <myproc>
80103355:	8b 40 24             	mov    0x24(%eax),%eax
80103358:	85 c0                	test   %eax,%eax
8010335a:	75 33                	jne    8010338f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010335c:	89 3c 24             	mov    %edi,(%esp)
8010335f:	e8 fc 0b 00 00       	call   80103f60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 60 09 00 00       	call   80103cd0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103370:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103376:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010337c:	05 00 02 00 00       	add    $0x200,%eax
80103381:	39 c2                	cmp    %eax,%edx
80103383:	75 23                	jne    801033a8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103385:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338b:	85 d2                	test   %edx,%edx
8010338d:	75 c1                	jne    80103350 <pipewrite+0x50>
        release(&p->lock);
8010338f:	89 1c 24             	mov    %ebx,(%esp)
80103392:	e8 99 10 00 00       	call   80104430 <release>
        return -1;
80103397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010339c:	83 c4 1c             	add    $0x1c,%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033ab:	8d 42 01             	lea    0x1(%edx),%eax
801033ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033b4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033be:	0f b6 09             	movzbl (%ecx),%ecx
801033c1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033c8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033cb:	0f 85 6c ff ff ff    	jne    8010333d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d7:	89 04 24             	mov    %eax,(%esp)
801033da:	e8 81 0b 00 00       	call   80103f60 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 49 10 00 00       	call   80104430 <release>
  return n;
801033e7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ea:	eb b0                	jmp    8010339c <pipewrite+0x9c>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 75 08             	mov    0x8(%ebp),%esi
801033fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ff:	89 34 24             	mov    %esi,(%esp)
80103402:	e8 39 0f 00 00       	call   80104340 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103407:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103413:	75 5b                	jne    80103470 <piperead+0x80>
80103415:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010341b:	85 db                	test   %ebx,%ebx
8010341d:	74 51                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010341f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103425:	eb 25                	jmp    8010344c <piperead+0x5c>
80103427:	90                   	nop
80103428:	89 74 24 04          	mov    %esi,0x4(%esp)
8010342c:	89 1c 24             	mov    %ebx,(%esp)
8010342f:	e8 9c 08 00 00       	call   80103cd0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103434:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103440:	75 2e                	jne    80103470 <piperead+0x80>
80103442:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	74 24                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
8010344c:	e8 6f 02 00 00       	call   801036c0 <myproc>
80103451:	8b 48 24             	mov    0x24(%eax),%ecx
80103454:	85 c9                	test   %ecx,%ecx
80103456:	74 d0                	je     80103428 <piperead+0x38>
      release(&p->lock);
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 d0 0f 00 00       	call   80104430 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5f                   	pop    %edi
8010346b:	5d                   	pop    %ebp
8010346c:	c3                   	ret    
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103470:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103473:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103475:	85 d2                	test   %edx,%edx
80103477:	7f 2b                	jg     801034a4 <piperead+0xb4>
80103479:	eb 31                	jmp    801034ac <piperead+0xbc>
8010347b:	90                   	nop
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103480:	8d 48 01             	lea    0x1(%eax),%ecx
80103483:	25 ff 01 00 00       	and    $0x1ff,%eax
80103488:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010348e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103493:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103496:	83 c3 01             	add    $0x1,%ebx
80103499:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010349c:	74 0e                	je     801034ac <piperead+0xbc>
    if(p->nread == p->nwrite)
8010349e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034aa:	75 d4                	jne    80103480 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ac:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 a6 0a 00 00       	call   80103f60 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 6e 0f 00 00       	call   80104430 <release>
  return i;
}
801034c2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034c5:	89 d8                	mov    %ebx,%eax
}
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034e3:	e8 58 0e 00 00       	call   80104340 <acquire>
801034e8:	eb 18                	jmp    80103502 <allocproc+0x32>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801034f6:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801034fc:	0f 84 86 00 00 00    	je     80103588 <allocproc+0xb8>
    if(p->state == UNUSED)
80103502:	8b 43 0c             	mov    0xc(%ebx),%eax
80103505:	85 c0                	test   %eax,%eax
80103507:	75 e7                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103509:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 31; // added

  release(&ptable.lock);
8010350e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103515:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  p->priority = 31; // added
8010351c:	c7 83 84 00 00 00 1f 	movl   $0x1f,0x84(%ebx)
80103523:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103526:	8d 50 01             	lea    0x1(%eax),%edx
80103529:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010352f:	89 43 10             	mov    %eax,0x10(%ebx)
  p->priority = 31; // added

  release(&ptable.lock);
80103532:	e8 f9 0e 00 00       	call   80104430 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103537:	e8 74 ef ff ff       	call   801024b0 <kalloc>
8010353c:	85 c0                	test   %eax,%eax
8010353e:	89 43 08             	mov    %eax,0x8(%ebx)
80103541:	74 59                	je     8010359c <allocproc+0xcc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103543:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103549:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010354e:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103551:	c7 40 14 8e 56 10 80 	movl   $0x8010568e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103558:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010355f:	00 
80103560:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103567:	00 
80103568:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010356b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010356e:	e8 0d 0f 00 00       	call   80104480 <memset>
  p->context->eip = (uint)forkret;
80103573:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103576:	c7 40 10 b0 35 10 80 	movl   $0x801035b0,0x10(%eax)

  return p;
8010357d:	89 d8                	mov    %ebx,%eax
}
8010357f:	83 c4 14             	add    $0x14,%esp
80103582:	5b                   	pop    %ebx
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
80103585:	8d 76 00             	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103588:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358f:	e8 9c 0e 00 00       	call   80104430 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103594:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103597:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103599:	5b                   	pop    %ebx
8010359a:	5d                   	pop    %ebp
8010359b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010359c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035a3:	eb da                	jmp    8010357f <allocproc+0xaf>
801035a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035bd:	e8 6e 0e 00 00       	call   80104430 <release>

  if (first) {
801035c2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035d7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035de:	00 00 00 
    iinit(ROOTDEV);
801035e1:	e8 9a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801035e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ed:	e8 8e f4 ff ff       	call   80102a80 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035f2:	c9                   	leave  
801035f3:	c3                   	ret    
801035f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103600 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103606:	c7 44 24 04 15 74 10 	movl   $0x80107415,0x4(%esp)
8010360d:	80 
8010360e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103615:	e8 36 0c 00 00       	call   80104250 <initlock>
}
8010361a:	c9                   	leave  
8010361b:	c3                   	ret    
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103620 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103628:	9c                   	pushf  
80103629:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010362a:	f6 c4 02             	test   $0x2,%ah
8010362d:	75 57                	jne    80103686 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010362f:	e8 3c f1 ff ff       	call   80102770 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103634:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010363a:	85 f6                	test   %esi,%esi
8010363c:	7e 3c                	jle    8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010363e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103645:	39 c2                	cmp    %eax,%edx
80103647:	74 2d                	je     80103676 <mycpu+0x56>
80103649:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010364e:	31 d2                	xor    %edx,%edx
80103650:	83 c2 01             	add    $0x1,%edx
80103653:	39 f2                	cmp    %esi,%edx
80103655:	74 23                	je     8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103657:	0f b6 19             	movzbl (%ecx),%ebx
8010365a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103660:	39 c3                	cmp    %eax,%ebx
80103662:	75 ec                	jne    80103650 <mycpu+0x30>
      return &cpus[i];
80103664:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103670:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103675:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103676:	31 d2                	xor    %edx,%edx
80103678:	eb ea                	jmp    80103664 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010367a:	c7 04 24 1c 74 10 80 	movl   $0x8010741c,(%esp)
80103681:	e8 da cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103686:	c7 04 24 f8 74 10 80 	movl   $0x801074f8,(%esp)
8010368d:	e8 ce cc ff ff       	call   80100360 <panic>
80103692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036a6:	e8 75 ff ff ff       	call   80103620 <mycpu>
}
801036ab:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036ac:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036b1:	c1 f8 04             	sar    $0x4,%eax
801036b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ba:	c3                   	ret    
801036bb:	90                   	nop
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036c7:	e8 34 0c 00 00       	call   80104300 <pushcli>
  c = mycpu();
801036cc:	e8 4f ff ff ff       	call   80103620 <mycpu>
  p = c->proc;
801036d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036d7:	e8 e4 0c 00 00       	call   801043c0 <popcli>
  return p;
}
801036dc:	83 c4 04             	add    $0x4,%esp
801036df:	89 d8                	mov    %ebx,%eax
801036e1:	5b                   	pop    %ebx
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
801036e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036f0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801036f7:	e8 d4 fd ff ff       	call   801034d0 <allocproc>
801036fc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801036fe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103703:	e8 08 35 00 00       	call   80106c10 <setupkvm>
80103708:	85 c0                	test   %eax,%eax
8010370a:	89 43 04             	mov    %eax,0x4(%ebx)
8010370d:	0f 84 d4 00 00 00    	je     801037e7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103713:	89 04 24             	mov    %eax,(%esp)
80103716:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010371d:	00 
8010371e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103725:	80 
80103726:	e8 15 32 00 00       	call   80106940 <inituvm>
  p->sz = PGSIZE;
8010372b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103731:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103738:	00 
80103739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103740:	00 
80103741:	8b 43 18             	mov    0x18(%ebx),%eax
80103744:	89 04 24             	mov    %eax,(%esp)
80103747:	e8 34 0d 00 00       	call   80104480 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010374c:	8b 43 18             	mov    0x18(%ebx),%eax
8010374f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103754:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103759:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010375d:	8b 43 18             	mov    0x18(%ebx),%eax
80103760:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010376b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010376f:	8b 43 18             	mov    0x18(%ebx),%eax
80103772:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103776:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010377a:	8b 43 18             	mov    0x18(%ebx),%eax
8010377d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010378e:	8b 43 18             	mov    0x18(%ebx),%eax
80103791:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103798:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010379b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037a2:	00 
801037a3:	c7 44 24 04 45 74 10 	movl   $0x80107445,0x4(%esp)
801037aa:	80 
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 ad 0e 00 00       	call   80104660 <safestrcpy>
  p->cwd = namei("/");
801037b3:	c7 04 24 4e 74 10 80 	movl   $0x8010744e,(%esp)
801037ba:	e8 51 e7 ff ff       	call   80101f10 <namei>
801037bf:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801037c2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037c9:	e8 72 0b 00 00       	call   80104340 <acquire>

  p->state = RUNNABLE;
801037ce:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801037d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037dc:	e8 4f 0c 00 00       	call   80104430 <release>
}
801037e1:	83 c4 14             	add    $0x14,%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5d                   	pop    %ebp
801037e6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801037e7:	c7 04 24 2c 74 10 80 	movl   $0x8010742c,(%esp)
801037ee:	e8 6d cb ff ff       	call   80100360 <panic>
801037f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	83 ec 10             	sub    $0x10,%esp
80103808:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010380b:	e8 b0 fe ff ff       	call   801036c0 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103810:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103813:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103815:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103817:	7e 2f                	jle    80103848 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103819:	01 c6                	add    %eax,%esi
8010381b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010381f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103823:	8b 43 04             	mov    0x4(%ebx),%eax
80103826:	89 04 24             	mov    %eax,(%esp)
80103829:	e8 52 32 00 00       	call   80106a80 <allocuvm>
8010382e:	85 c0                	test   %eax,%eax
80103830:	74 36                	je     80103868 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103832:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103834:	89 1c 24             	mov    %ebx,(%esp)
80103837:	e8 f4 2f 00 00       	call   80106830 <switchuvm>
  return 0;
8010383c:	31 c0                	xor    %eax,%eax
}
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
80103845:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103848:	74 e8                	je     80103832 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010384a:	01 c6                	add    %eax,%esi
8010384c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103850:	89 44 24 04          	mov    %eax,0x4(%esp)
80103854:	8b 43 04             	mov    0x4(%ebx),%eax
80103857:	89 04 24             	mov    %eax,(%esp)
8010385a:	e8 11 33 00 00       	call   80106b70 <deallocuvm>
8010385f:	85 c0                	test   %eax,%eax
80103861:	75 cf                	jne    80103832 <growproc+0x32>
80103863:	90                   	nop
80103864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010386d:	eb cf                	jmp    8010383e <growproc+0x3e>
8010386f:	90                   	nop

80103870 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103879:	e8 42 fe ff ff       	call   801036c0 <myproc>
8010387e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103880:	e8 4b fc ff ff       	call   801034d0 <allocproc>
80103885:	85 c0                	test   %eax,%eax
80103887:	89 c7                	mov    %eax,%edi
80103889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010388c:	0f 84 d0 00 00 00    	je     80103962 <fork+0xf2>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103892:	8b 03                	mov    (%ebx),%eax
80103894:	89 44 24 04          	mov    %eax,0x4(%esp)
80103898:	8b 43 04             	mov    0x4(%ebx),%eax
8010389b:	89 04 24             	mov    %eax,(%esp)
8010389e:	e8 4d 34 00 00       	call   80106cf0 <copyuvm>
801038a3:	85 c0                	test   %eax,%eax
801038a5:	89 47 04             	mov    %eax,0x4(%edi)
801038a8:	0f 84 bb 00 00 00    	je     80103969 <fork+0xf9>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038ae:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038b0:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038b8:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038ba:	89 f8                	mov    %edi,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
801038bc:	89 5f 14             	mov    %ebx,0x14(%edi)
  *np->tf = *curproc->tf;
801038bf:	8b 7f 18             	mov    0x18(%edi),%edi
801038c2:	8b 73 18             	mov    0x18(%ebx),%esi
801038c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038c7:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801038c9:	8b 40 18             	mov    0x18(%eax),%eax
801038cc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038d3:	90                   	nop
801038d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801038d8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038dc:	85 c0                	test   %eax,%eax
801038de:	74 0f                	je     801038ef <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038e0:	89 04 24             	mov    %eax,(%esp)
801038e3:	e8 f8 d4 ff ff       	call   80100de0 <filedup>
801038e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038eb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038ef:	83 c6 01             	add    $0x1,%esi
801038f2:	83 fe 10             	cmp    $0x10,%esi
801038f5:	75 e1                	jne    801038d8 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038f7:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038fa:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038fd:	89 04 24             	mov    %eax,(%esp)
80103900:	e8 8b dd ff ff       	call   80101690 <idup>
80103905:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103908:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010390e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103912:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103919:	00 
8010391a:	89 04 24             	mov    %eax,(%esp)
8010391d:	e8 3e 0d 00 00       	call   80104660 <safestrcpy>

  

  pid = np->pid;
80103922:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103925:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010392c:	e8 0f 0a 00 00       	call   80104340 <acquire>

  np->state = RUNNABLE;
80103931:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->priority = 31; // added lab2
80103938:	c7 87 84 00 00 00 1f 	movl   $0x1f,0x84(%edi)
8010393f:	00 00 00 
  np->old_priority = 31; // added lab2
80103942:	c7 87 88 00 00 00 1f 	movl   $0x1f,0x88(%edi)
80103949:	00 00 00 

  release(&ptable.lock);
8010394c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103953:	e8 d8 0a 00 00       	call   80104430 <release>

  return pid;
80103958:	89 d8                	mov    %ebx,%eax
}
8010395a:	83 c4 1c             	add    $0x1c,%esp
8010395d:	5b                   	pop    %ebx
8010395e:	5e                   	pop    %esi
8010395f:	5f                   	pop    %edi
80103960:	5d                   	pop    %ebp
80103961:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103967:	eb f1                	jmp    8010395a <fork+0xea>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103969:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010396c:	8b 43 08             	mov    0x8(%ebx),%eax
8010396f:	89 04 24             	mov    %eax,(%esp)
80103972:	e8 89 e9 ff ff       	call   80102300 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
8010397c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103983:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010398a:	eb ce                	jmp    8010395a <fork+0xea>
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103999:	e8 82 fc ff ff       	call   80103620 <mycpu>
  int hi_prty = 0;
  c->proc = 0;
8010399e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039a5:	00 00 00 
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
801039a8:	89 c6                	mov    %eax,%esi
801039aa:	8d 40 04             	lea    0x4(%eax),%eax
801039ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
801039b0:	fb                   	sti    
    // Loop over process table looking for process to run.
    
    //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
     // if(p->state != RUNNABLE)
      //  continue;
	hi_prty = 0;
801039b1:	31 ff                	xor    %edi,%edi
      // ADDED get the higest priorty from ptable
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801039b8:	eb 12                	jmp    801039cc <scheduler+0x3c>
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039c0:	05 8c 00 00 00       	add    $0x8c,%eax
801039c5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801039ca:	74 1d                	je     801039e9 <scheduler+0x59>
        if( p->state != RUNNABLE){
801039cc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801039d0:	75 ee                	jne    801039c0 <scheduler+0x30>
          continue;
        }
        if(hi_prty < p->priority){ // reset the max priority to new value; 
801039d2:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801039d8:	39 cf                	cmp    %ecx,%edi
801039da:	0f 4c f9             	cmovl  %ecx,%edi
    //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
     // if(p->state != RUNNABLE)
      //  continue;
	hi_prty = 0;
      // ADDED get the higest priorty from ptable
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039dd:	05 8c 00 00 00       	add    $0x8c,%eax
801039e2:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801039e7:	75 e3                	jne    801039cc <scheduler+0x3c>
        if(hi_prty < p->priority){ // reset the max priority to new value; 
          hi_prty= p->priority;
        }
      }
      // ADDED end *******************************
      acquire(&ptable.lock);
801039e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f0:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
        if(hi_prty < p->priority){ // reset the max priority to new value; 
          hi_prty= p->priority;
        }
      }
      // ADDED end *******************************
      acquire(&ptable.lock);
801039f5:	e8 46 09 00 00       	call   80104340 <acquire>
801039fa:	eb 12                	jmp    80103a0e <scheduler+0x7e>
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a00:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103a06:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103a0c:	74 72                	je     80103a80 <scheduler+0xf0>
	if(p->state!=RUNNABLE){
80103a0e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a12:	75 ec                	jne    80103a00 <scheduler+0x70>
//		if(p->priority <= hi_prty){
//			p->priority += 5;
//		}
		continue;
	}
	if(p->priority < hi_prty){ // added to check priority
80103a14:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103a1a:	39 f8                	cmp    %edi,%eax
80103a1c:	7c e2                	jl     80103a00 <scheduler+0x70>
		continue; 
	}
        if(p->priority <= hi_prty){
80103a1e:	7f 09                	jg     80103a29 <scheduler+0x99>
                p->priority += 10;
80103a20:	83 c0 0a             	add    $0xa,%eax
80103a23:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)

      
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a2f:	89 1c 24             	mov    %ebx,(%esp)
80103a32:	e8 f9 2d 00 00       	call   80106830 <switchuvm>
      p->state = RUNNING;
80103a37:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

	if(c->proc->state == RUNNING && c->proc->priority >= 10){ c->proc->priority -= 10;}
80103a3e:	8b 86 ac 00 00 00    	mov    0xac(%esi),%eax
80103a44:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103a48:	74 4e                	je     80103a98 <scheduler+0x108>

      swtch(&(c->scheduler), p->context);
80103a4a:	8b 43 1c             	mov    0x1c(%ebx),%eax
          hi_prty= p->priority;
        }
      }
      // ADDED end *******************************
      acquire(&ptable.lock);
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a4d:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      switchuvm(p);
      p->state = RUNNING;

	if(c->proc->state == RUNNING && c->proc->priority >= 10){ c->proc->priority -= 10;}

      swtch(&(c->scheduler), p->context);
80103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a5a:	89 04 24             	mov    %eax,(%esp)
80103a5d:	e8 59 0c 00 00       	call   801046bb <swtch>
      switchkvm();
80103a62:	e8 a9 2d 00 00       	call   80106810 <switchkvm>
          hi_prty= p->priority;
        }
      }
      // ADDED end *******************************
      acquire(&ptable.lock);
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a67:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a6d:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a74:	00 00 00 
          hi_prty= p->priority;
        }
      }
      // ADDED end *******************************
      acquire(&ptable.lock);
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a77:	75 95                	jne    80103a0e <scheduler+0x7e>
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      }
    release(&ptable.lock);
80103a80:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a87:	e8 a4 09 00 00       	call   80104430 <release>

  }
80103a8c:	e9 1f ff ff ff       	jmp    801039b0 <scheduler+0x20>
80103a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

	if(c->proc->state == RUNNING && c->proc->priority >= 10){ c->proc->priority -= 10;}
80103a98:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103a9e:	83 f9 09             	cmp    $0x9,%ecx
80103aa1:	7e a7                	jle    80103a4a <scheduler+0xba>
80103aa3:	83 e9 0a             	sub    $0xa,%ecx
80103aa6:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
80103aac:	eb 9c                	jmp    80103a4a <scheduler+0xba>
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103ab8:	e8 03 fc ff ff       	call   801036c0 <myproc>

  if(!holding(&ptable.lock))
80103abd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103ac4:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103ac6:	e8 05 08 00 00       	call   801042d0 <holding>
80103acb:	85 c0                	test   %eax,%eax
80103acd:	74 4f                	je     80103b1e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103acf:	e8 4c fb ff ff       	call   80103620 <mycpu>
80103ad4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103adb:	75 65                	jne    80103b42 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103add:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ae1:	74 53                	je     80103b36 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae3:	9c                   	pushf  
80103ae4:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103ae5:	f6 c4 02             	test   $0x2,%ah
80103ae8:	75 40                	jne    80103b2a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103aea:	e8 31 fb ff ff       	call   80103620 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103aef:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103af2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103af8:	e8 23 fb ff ff       	call   80103620 <mycpu>
80103afd:	8b 40 04             	mov    0x4(%eax),%eax
80103b00:	89 1c 24             	mov    %ebx,(%esp)
80103b03:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b07:	e8 af 0b 00 00       	call   801046bb <swtch>
  mycpu()->intena = intena;
80103b0c:	e8 0f fb ff ff       	call   80103620 <mycpu>
80103b11:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	5b                   	pop    %ebx
80103b1b:	5e                   	pop    %esi
80103b1c:	5d                   	pop    %ebp
80103b1d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b1e:	c7 04 24 50 74 10 80 	movl   $0x80107450,(%esp)
80103b25:	e8 36 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b2a:	c7 04 24 7c 74 10 80 	movl   $0x8010747c,(%esp)
80103b31:	e8 2a c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b36:	c7 04 24 6e 74 10 80 	movl   $0x8010746e,(%esp)
80103b3d:	e8 1e c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b42:	c7 04 24 62 74 10 80 	movl   $0x80107462,(%esp)
80103b49:	e8 12 c8 ff ff       	call   80100360 <panic>
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait(0) to find out it exited.
void
exit(int status)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b54:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait(0) to find out it exited.
void
exit(int status)
{
80103b56:	53                   	push   %ebx
80103b57:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b5a:	e8 61 fb ff ff       	call   801036c0 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b5f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait(0) to find out it exited.
void
exit(int status)
{
  struct proc *curproc = myproc();
80103b65:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b67:	0f 84 17 01 00 00    	je     80103c84 <exit+0x134>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 10                	je     80103b88 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b78:	89 04 24             	mov    %eax,(%esp)
80103b7b:	e8 b0 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b80:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b87:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103b88:	83 c6 01             	add    $0x1,%esi
80103b8b:	83 fe 10             	cmp    $0x10,%esi
80103b8e:	75 e0                	jne    80103b70 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b90:	e8 8b ef ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103b95:	8b 43 68             	mov    0x68(%ebx),%eax
80103b98:	89 04 24             	mov    %eax,(%esp)
80103b9b:	e8 40 dc ff ff       	call   801017e0 <iput>
  end_op();
80103ba0:	e8 eb ef ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103ba5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103bac:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bb3:	e8 88 07 00 00       	call   80104340 <acquire>

  // Parent might be sleeping in wait(0).
  wakeup1(curproc->parent);
80103bb8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bbb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bc0:	eb 14                	jmp    80103bd6 <exit+0x86>
80103bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bc8:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103bce:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103bd4:	74 20                	je     80103bf6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103bd6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bda:	75 ec                	jne    80103bc8 <exit+0x78>
80103bdc:	3b 42 20             	cmp    0x20(%edx),%eax
80103bdf:	75 e7                	jne    80103bc8 <exit+0x78>
      p->state = RUNNABLE;
80103be1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103be8:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103bee:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103bf4:	75 e0                	jne    80103bd6 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103bf6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103bfb:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103c00:	eb 14                	jmp    80103c16 <exit+0xc6>
80103c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait(0).
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c08:	81 c1 8c 00 00 00    	add    $0x8c,%ecx
80103c0e:	81 f9 54 50 11 80    	cmp    $0x80115054,%ecx
80103c14:	74 3c                	je     80103c52 <exit+0x102>
    if(p->parent == curproc){
80103c16:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c19:	75 ed                	jne    80103c08 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c1b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c1f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c22:	75 e4                	jne    80103c08 <exit+0xb8>
80103c24:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c29:	eb 13                	jmp    80103c3e <exit+0xee>
80103c2b:	90                   	nop
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c30:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103c36:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103c3c:	74 ca                	je     80103c08 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103c3e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c42:	75 ec                	jne    80103c30 <exit+0xe0>
80103c44:	3b 42 20             	cmp    0x20(%edx),%eax
80103c47:	75 e7                	jne    80103c30 <exit+0xe0>
      p->state = RUNNABLE;
80103c49:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c50:	eb de                	jmp    80103c30 <exit+0xe0>
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  curproc->status = status;
80103c52:	8b 45 08             	mov    0x8(%ebp),%eax
80103c55:	89 43 7c             	mov    %eax,0x7c(%ebx)

  if (curproc->priority != curproc->old_priority)
80103c58:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103c5e:	39 83 84 00 00 00    	cmp    %eax,0x84(%ebx)
80103c64:	74 06                	je     80103c6c <exit+0x11c>
	curproc->priority = curproc->old_priority;
80103c66:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)


  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c6c:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c73:	e8 38 fe ff ff       	call   80103ab0 <sched>
  panic("zombie exit");
80103c78:	c7 04 24 9d 74 10 80 	movl   $0x8010749d,(%esp)
80103c7f:	e8 dc c6 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c84:	c7 04 24 90 74 10 80 	movl   $0x80107490,(%esp)
80103c8b:	e8 d0 c6 ff ff       	call   80100360 <panic>

80103c90 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c96:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c9d:	e8 9e 06 00 00       	call   80104340 <acquire>
  myproc()->state = RUNNABLE;
80103ca2:	e8 19 fa ff ff       	call   801036c0 <myproc>
80103ca7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cae:	e8 fd fd ff ff       	call   80103ab0 <sched>
  release(&ptable.lock);
80103cb3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cba:	e8 71 07 00 00       	call   80104430 <release>
}
80103cbf:	c9                   	leave  
80103cc0:	c3                   	ret    
80103cc1:	eb 0d                	jmp    80103cd0 <sleep>
80103cc3:	90                   	nop
80103cc4:	90                   	nop
80103cc5:	90                   	nop
80103cc6:	90                   	nop
80103cc7:	90                   	nop
80103cc8:	90                   	nop
80103cc9:	90                   	nop
80103cca:	90                   	nop
80103ccb:	90                   	nop
80103ccc:	90                   	nop
80103ccd:	90                   	nop
80103cce:	90                   	nop
80103ccf:	90                   	nop

80103cd0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
80103cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103cdf:	e8 dc f9 ff ff       	call   801036c0 <myproc>
  
  if(p == 0)
80103ce4:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103ce6:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103ce8:	0f 84 7c 00 00 00    	je     80103d6a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103cee:	85 f6                	test   %esi,%esi
80103cf0:	74 6c                	je     80103d5e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103cf2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103cf8:	74 46                	je     80103d40 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103cfa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d01:	e8 3a 06 00 00       	call   80104340 <acquire>
    release(lk);
80103d06:	89 34 24             	mov    %esi,(%esp)
80103d09:	e8 22 07 00 00       	call   80104430 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d0e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d11:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d18:	e8 93 fd ff ff       	call   80103ab0 <sched>

  // Tidy up.
  p->chan = 0;
80103d1d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d24:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d2b:	e8 00 07 00 00       	call   80104430 <release>
    acquire(lk);
80103d30:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103d33:	83 c4 1c             	add    $0x1c,%esp
80103d36:	5b                   	pop    %ebx
80103d37:	5e                   	pop    %esi
80103d38:	5f                   	pop    %edi
80103d39:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d3a:	e9 01 06 00 00       	jmp    80104340 <acquire>
80103d3f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d40:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d43:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d4a:	e8 61 fd ff ff       	call   80103ab0 <sched>

  // Tidy up.
  p->chan = 0;
80103d4f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d56:	83 c4 1c             	add    $0x1c,%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5f                   	pop    %edi
80103d5c:	5d                   	pop    %ebp
80103d5d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d5e:	c7 04 24 af 74 10 80 	movl   $0x801074af,(%esp)
80103d65:	e8 f6 c5 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d6a:	c7 04 24 a9 74 10 80 	movl   $0x801074a9,(%esp)
80103d71:	e8 ea c5 ff ff       	call   80100360 <panic>
80103d76:	8d 76 00             	lea    0x0(%esi),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(int *status)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
80103d85:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d88:	e8 33 f9 ff ff       	call   801036c0 <myproc>
  
  acquire(&ptable.lock);
80103d8d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(int *status)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d94:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103d96:	e8 a5 05 00 00       	call   80104340 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103d9b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d9d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103da2:	eb 12                	jmp    80103db6 <wait+0x36>
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103da8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103dae:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103db4:	74 22                	je     80103dd8 <wait+0x58>
      if(p->parent != curproc)
80103db6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103db9:	75 ed                	jne    80103da8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103dbb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dbf:	74 34                	je     80103df5 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dcc:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103dd2:	75 e2                	jne    80103db6 <wait+0x36>
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	74 76                	je     80103e52 <wait+0xd2>
80103ddc:	8b 46 24             	mov    0x24(%esi),%eax
80103ddf:	85 c0                	test   %eax,%eax
80103de1:	75 6f                	jne    80103e52 <wait+0xd2>
     
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103de3:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103dea:	80 
80103deb:	89 34 24             	mov    %esi,(%esp)
80103dee:	e8 dd fe ff ff       	call   80103cd0 <sleep>
  }
80103df3:	eb a6                	jmp    80103d9b <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103df5:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103df8:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103dfb:	89 04 24             	mov    %eax,(%esp)
80103dfe:	e8 fd e4 ff ff       	call   80102300 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e03:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e06:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e0d:	89 04 24             	mov    %eax,(%esp)
80103e10:	e8 7b 2d 00 00       	call   80106b90 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
	*status = p->status;
80103e15:	8b 45 08             	mov    0x8(%ebp),%eax
80103e18:	8b 53 7c             	mov    0x7c(%ebx),%edx
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103e1b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e22:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e29:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e2d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	*status = p->status;
80103e3b:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
80103e3d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e44:	e8 e7 05 00 00       	call   80104430 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e49:	83 c4 10             	add    $0x10,%esp
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
	*status = p->status;
        release(&ptable.lock);
        return pid;
80103e4c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e4e:	5b                   	pop    %ebx
80103e4f:	5e                   	pop    %esi
80103e50:	5d                   	pop    %ebp
80103e51:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e52:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e59:	e8 d2 05 00 00       	call   80104430 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e5e:	83 c4 10             	add    $0x10,%esp

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
     
      return -1;
80103e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e66:	5b                   	pop    %ebx
80103e67:	5e                   	pop    %esi
80103e68:	5d                   	pop    %ebp
80103e69:	c3                   	ret    
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <waitpid>:

int waitpid(int pid, int *status, int options){
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 1c             	sub    $0x1c,%esp
80103e79:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *p;
  int temp_pid, got_pid;
  struct proc *curproc = myproc();
80103e7c:	e8 3f f8 ff ff       	call   801036c0 <myproc>

  acquire(&ptable.lock);
80103e81:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
}

int waitpid(int pid, int *status, int options){
  struct proc *p;
  int temp_pid, got_pid;
  struct proc *curproc = myproc();
80103e88:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  acquire(&ptable.lock);
80103e8b:	e8 b0 04 00 00       	call   80104340 <acquire>
80103e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(;;){
// scan through table looking for exited children
    got_pid = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e93:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e98:	eb 14                	jmp    80103eae <waitpid+0x3e>
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ea0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ea6:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103eac:	74 32                	je     80103ee0 <waitpid+0x70>
      if(p->pid == pid){
80103eae:	8b 73 10             	mov    0x10(%ebx),%esi
80103eb1:	39 fe                	cmp    %edi,%esi
80103eb3:	75 eb                	jne    80103ea0 <waitpid+0x30>
	got_pid = 1;
	if(p->state == ZOMBIE){
80103eb5:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eb9:	74 40                	je     80103efb <waitpid+0x8b>
	  break;
	}
     }
   }
// no point in waiting if no children
    if (got_pid == 0 || curproc->killed){
80103ebb:	8b 50 24             	mov    0x24(%eax),%edx
	  p->status = 0;
	  release(&ptable.lock);
	  return temp_pid;
	}
       	else{
	  curproc->wait_pid = p->pid;
80103ebe:	89 b8 80 00 00 00    	mov    %edi,0x80(%eax)
	  break;
	}
     }
   }
// no point in waiting if no children
    if (got_pid == 0 || curproc->killed){
80103ec4:	85 d2                	test   %edx,%edx
80103ec6:	75 18                	jne    80103ee0 <waitpid+0x70>
	release(&ptable.lock);
	return -1;
    }
// wait for children to exit. (see wakeup1 call in proc_exit)
    else if(got_pid == 1){
	sleep(curproc, &ptable.lock); // DOC: wait-sleep
80103ec8:	89 04 24             	mov    %eax,(%esp)
80103ecb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103ed2:	80 
80103ed3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ed6:	e8 f5 fd ff ff       	call   80103cd0 <sleep>
80103edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ede:	eb b3                	jmp    80103e93 <waitpid+0x23>
	}
     }
   }
// no point in waiting if no children
    if (got_pid == 0 || curproc->killed){
	release(&ptable.lock);
80103ee0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
	return -1;
80103ee7:	be ff ff ff ff       	mov    $0xffffffff,%esi
	}
     }
   }
// no point in waiting if no children
    if (got_pid == 0 || curproc->killed){
	release(&ptable.lock);
80103eec:	e8 3f 05 00 00       	call   80104430 <release>
// wait for children to exit. (see wakeup1 call in proc_exit)
    else if(got_pid == 1){
	sleep(curproc, &ptable.lock); // DOC: wait-sleep
    }
  }
}
80103ef1:	83 c4 1c             	add    $0x1c,%esp
80103ef4:	89 f0                	mov    %esi,%eax
80103ef6:	5b                   	pop    %ebx
80103ef7:	5e                   	pop    %esi
80103ef8:	5f                   	pop    %edi
80103ef9:	5d                   	pop    %ebp
80103efa:	c3                   	ret    
      if(p->pid == pid){
	got_pid = 1;
	if(p->state == ZOMBIE){
	// found one
	  temp_pid = p->pid;
	  kfree(p->kstack);
80103efb:	8b 43 08             	mov    0x8(%ebx),%eax
80103efe:	89 04 24             	mov    %eax,(%esp)
80103f01:	e8 fa e3 ff ff       	call   80102300 <kfree>
	  p->kstack = 0;
          freevm(p->pgdir);
80103f06:	8b 43 04             	mov    0x4(%ebx),%eax
	got_pid = 1;
	if(p->state == ZOMBIE){
	// found one
	  temp_pid = p->pid;
	  kfree(p->kstack);
	  p->kstack = 0;
80103f09:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
          freevm(p->pgdir);
80103f10:	89 04 24             	mov    %eax,(%esp)
80103f13:	e8 78 2c 00 00       	call   80106b90 <freevm>
	  p->pid = 0;
	  p->parent = 0;
	  p->name[0] = 0;
	  p->killed = 0;
	  p->state = UNUSED;
	  *status = p->status;
80103f18:	8b 53 7c             	mov    0x7c(%ebx),%edx
80103f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
	// found one
	  temp_pid = p->pid;
	  kfree(p->kstack);
	  p->kstack = 0;
          freevm(p->pgdir);
	  p->pid = 0;
80103f1e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
	  p->parent = 0;
80103f25:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	  p->name[0] = 0;
80103f2c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
	  p->killed = 0;
80103f30:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	  p->state = UNUSED;
80103f37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	  *status = p->status;
80103f3e:	89 10                	mov    %edx,(%eax)
	  p->status = 0;
	  release(&ptable.lock);
80103f40:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
	  p->parent = 0;
	  p->name[0] = 0;
	  p->killed = 0;
	  p->state = UNUSED;
	  *status = p->status;
	  p->status = 0;
80103f47:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	  release(&ptable.lock);
80103f4e:	e8 dd 04 00 00       	call   80104430 <release>
	  return temp_pid;
80103f53:	eb 9c                	jmp    80103ef1 <waitpid+0x81>
80103f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 14             	sub    $0x14,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f6a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f71:	e8 ca 03 00 00       	call   80104340 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f76:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f7b:	eb 0f                	jmp    80103f8c <wakeup+0x2c>
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
80103f80:	05 8c 00 00 00       	add    $0x8c,%eax
80103f85:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103f8a:	74 24                	je     80103fb0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103f8c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f90:	75 ee                	jne    80103f80 <wakeup+0x20>
80103f92:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f95:	75 e9                	jne    80103f80 <wakeup+0x20>
      p->state = RUNNABLE;
80103f97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f9e:	05 8c 00 00 00       	add    $0x8c,%eax
80103fa3:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103fa8:	75 e2                	jne    80103f8c <wakeup+0x2c>
80103faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fb0:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103fb7:	83 c4 14             	add    $0x14,%esp
80103fba:	5b                   	pop    %ebx
80103fbb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fbc:	e9 6f 04 00 00       	jmp    80104430 <release>
80103fc1:	eb 0d                	jmp    80103fd0 <kill>
80103fc3:	90                   	nop
80103fc4:	90                   	nop
80103fc5:	90                   	nop
80103fc6:	90                   	nop
80103fc7:	90                   	nop
80103fc8:	90                   	nop
80103fc9:	90                   	nop
80103fca:	90                   	nop
80103fcb:	90                   	nop
80103fcc:	90                   	nop
80103fcd:	90                   	nop
80103fce:	90                   	nop
80103fcf:	90                   	nop

80103fd0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	53                   	push   %ebx
80103fd4:	83 ec 14             	sub    $0x14,%esp
80103fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103fda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fe1:	e8 5a 03 00 00       	call   80104340 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103feb:	eb 0f                	jmp    80103ffc <kill+0x2c>
80103fed:	8d 76 00             	lea    0x0(%esi),%esi
80103ff0:	05 8c 00 00 00       	add    $0x8c,%eax
80103ff5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103ffa:	74 3c                	je     80104038 <kill+0x68>
    if(p->pid == pid){
80103ffc:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fff:	75 ef                	jne    80103ff0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104001:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104005:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010400c:	74 1a                	je     80104028 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010400e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104015:	e8 16 04 00 00       	call   80104430 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010401a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
8010401d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010401f:	5b                   	pop    %ebx
80104020:	5d                   	pop    %ebp
80104021:	c3                   	ret    
80104022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104028:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010402f:	eb dd                	jmp    8010400e <kill+0x3e>
80104031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104038:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010403f:	e8 ec 03 00 00       	call   80104430 <release>
  return -1;
}
80104044:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80104047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010404c:	5b                   	pop    %ebx
8010404d:	5d                   	pop    %ebp
8010404e:	c3                   	ret    
8010404f:	90                   	nop

80104050 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010405b:	83 ec 4c             	sub    $0x4c,%esp
8010405e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104061:	eb 23                	jmp    80104086 <procdump+0x36>
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104068:	c7 04 24 3f 78 10 80 	movl   $0x8010783f,(%esp)
8010406f:	e8 dc c5 ff ff       	call   80100650 <cprintf>
80104074:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407a:	81 fb c0 50 11 80    	cmp    $0x801150c0,%ebx
80104080:	0f 84 8a 00 00 00    	je     80104110 <procdump+0xc0>
    if(p->state == UNUSED)
80104086:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104089:	85 c0                	test   %eax,%eax
8010408b:	74 e7                	je     80104074 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010408d:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104090:	ba c0 74 10 80       	mov    $0x801074c0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104095:	77 11                	ja     801040a8 <procdump+0x58>
80104097:	8b 14 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010409e:	b8 c0 74 10 80       	mov    $0x801074c0,%eax
801040a3:	85 d2                	test   %edx,%edx
801040a5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040a8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801040ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801040af:	89 54 24 08          	mov    %edx,0x8(%esp)
801040b3:	c7 04 24 c4 74 10 80 	movl   $0x801074c4,(%esp)
801040ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801040be:	e8 8d c5 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801040c3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040c7:	75 9f                	jne    80104068 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801040d0:	8b 43 b0             	mov    -0x50(%ebx),%eax
801040d3:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040d6:	8b 40 0c             	mov    0xc(%eax),%eax
801040d9:	83 c0 08             	add    $0x8,%eax
801040dc:	89 04 24             	mov    %eax,(%esp)
801040df:	e8 8c 01 00 00       	call   80104270 <getcallerpcs>
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801040e8:	8b 17                	mov    (%edi),%edx
801040ea:	85 d2                	test   %edx,%edx
801040ec:	0f 84 76 ff ff ff    	je     80104068 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040f2:	89 54 24 04          	mov    %edx,0x4(%esp)
801040f6:	83 c7 04             	add    $0x4,%edi
801040f9:	c7 04 24 01 6f 10 80 	movl   $0x80106f01,(%esp)
80104100:	e8 4b c5 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104105:	39 f7                	cmp    %esi,%edi
80104107:	75 df                	jne    801040e8 <procdump+0x98>
80104109:	e9 5a ff ff ff       	jmp    80104068 <procdump+0x18>
8010410e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104110:	83 c4 4c             	add    $0x4c,%esp
80104113:	5b                   	pop    %ebx
80104114:	5e                   	pop    %esi
80104115:	5f                   	pop    %edi
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <setpriority>:

void setpriority(int prty){
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 04             	sub    $0x4,%esp
80104127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc * p = myproc();
8010412a:	e8 91 f5 ff ff       	call   801036c0 <myproc>
  if (prty < 0 || prty > 31) {
8010412f:	83 fb 1f             	cmp    $0x1f,%ebx
80104132:	77 06                	ja     8010413a <setpriority+0x1a>
     return;
  }
  p->priority = prty; //added lab2
80104134:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  return;
}
8010413a:	83 c4 04             	add    $0x4,%esp
8010413d:	5b                   	pop    %ebx
8010413e:	5d                   	pop    %ebp
8010413f:	c3                   	ret    

80104140 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 14             	sub    $0x14,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010414a:	c7 44 24 04 38 75 10 	movl   $0x80107538,0x4(%esp)
80104151:	80 
80104152:	8d 43 04             	lea    0x4(%ebx),%eax
80104155:	89 04 24             	mov    %eax,(%esp)
80104158:	e8 f3 00 00 00       	call   80104250 <initlock>
  lk->name = name;
8010415d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104160:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104166:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010416d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104170:	83 c4 14             	add    $0x14,%esp
80104173:	5b                   	pop    %ebx
80104174:	5d                   	pop    %ebp
80104175:	c3                   	ret    
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	83 ec 10             	sub    $0x10,%esp
80104188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010418b:	8d 73 04             	lea    0x4(%ebx),%esi
8010418e:	89 34 24             	mov    %esi,(%esp)
80104191:	e8 aa 01 00 00       	call   80104340 <acquire>
  while (lk->locked) {
80104196:	8b 13                	mov    (%ebx),%edx
80104198:	85 d2                	test   %edx,%edx
8010419a:	74 16                	je     801041b2 <acquiresleep+0x32>
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801041a0:	89 74 24 04          	mov    %esi,0x4(%esp)
801041a4:	89 1c 24             	mov    %ebx,(%esp)
801041a7:	e8 24 fb ff ff       	call   80103cd0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041ac:	8b 03                	mov    (%ebx),%eax
801041ae:	85 c0                	test   %eax,%eax
801041b0:	75 ee                	jne    801041a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041b2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041b8:	e8 03 f5 ff ff       	call   801036c0 <myproc>
801041bd:	8b 40 10             	mov    0x10(%eax),%eax
801041c0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041c3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041c6:	83 c4 10             	add    $0x10,%esp
801041c9:	5b                   	pop    %ebx
801041ca:	5e                   	pop    %esi
801041cb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801041cc:	e9 5f 02 00 00       	jmp    80104430 <release>
801041d1:	eb 0d                	jmp    801041e0 <releasesleep>
801041d3:	90                   	nop
801041d4:	90                   	nop
801041d5:	90                   	nop
801041d6:	90                   	nop
801041d7:	90                   	nop
801041d8:	90                   	nop
801041d9:	90                   	nop
801041da:	90                   	nop
801041db:	90                   	nop
801041dc:	90                   	nop
801041dd:	90                   	nop
801041de:	90                   	nop
801041df:	90                   	nop

801041e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	83 ec 10             	sub    $0x10,%esp
801041e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041eb:	8d 73 04             	lea    0x4(%ebx),%esi
801041ee:	89 34 24             	mov    %esi,(%esp)
801041f1:	e8 4a 01 00 00       	call   80104340 <acquire>
  lk->locked = 0;
801041f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041fc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104203:	89 1c 24             	mov    %ebx,(%esp)
80104206:	e8 55 fd ff ff       	call   80103f60 <wakeup>
  release(&lk->lk);
8010420b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010420e:	83 c4 10             	add    $0x10,%esp
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104214:	e9 17 02 00 00       	jmp    80104430 <release>
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	83 ec 10             	sub    $0x10,%esp
80104228:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010422b:	8d 73 04             	lea    0x4(%ebx),%esi
8010422e:	89 34 24             	mov    %esi,(%esp)
80104231:	e8 0a 01 00 00       	call   80104340 <acquire>
  r = lk->locked;
80104236:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104238:	89 34 24             	mov    %esi,(%esp)
8010423b:	e8 f0 01 00 00       	call   80104430 <release>
  return r;
}
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	89 d8                	mov    %ebx,%eax
80104245:	5b                   	pop    %ebx
80104246:	5e                   	pop    %esi
80104247:	5d                   	pop    %ebp
80104248:	c3                   	ret    
80104249:	66 90                	xchg   %ax,%ax
8010424b:	66 90                	xchg   %ax,%ax
8010424d:	66 90                	xchg   %ax,%ax
8010424f:	90                   	nop

80104250 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104256:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010425f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104262:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret    
8010426b:	90                   	nop
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104276:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104279:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010427a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010427d:	31 c0                	xor    %eax,%eax
8010427f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104280:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104286:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010428c:	77 1a                	ja     801042a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010428e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104291:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104294:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104297:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104299:	83 f8 0a             	cmp    $0xa,%eax
8010429c:	75 e2                	jne    80104280 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010429e:	5b                   	pop    %ebx
8010429f:	5d                   	pop    %ebp
801042a0:	c3                   	ret    
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042af:	83 c0 01             	add    $0x1,%eax
801042b2:	83 f8 0a             	cmp    $0xa,%eax
801042b5:	74 e7                	je     8010429e <getcallerpcs+0x2e>
    pcs[i] = 0;
801042b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042be:	83 c0 01             	add    $0x1,%eax
801042c1:	83 f8 0a             	cmp    $0xa,%eax
801042c4:	75 e2                	jne    801042a8 <getcallerpcs+0x38>
801042c6:	eb d6                	jmp    8010429e <getcallerpcs+0x2e>
801042c8:	90                   	nop
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042d0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801042d1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042d3:	89 e5                	mov    %esp,%ebp
801042d5:	53                   	push   %ebx
801042d6:	83 ec 04             	sub    $0x4,%esp
801042d9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801042dc:	8b 0a                	mov    (%edx),%ecx
801042de:	85 c9                	test   %ecx,%ecx
801042e0:	74 10                	je     801042f2 <holding+0x22>
801042e2:	8b 5a 08             	mov    0x8(%edx),%ebx
801042e5:	e8 36 f3 ff ff       	call   80103620 <mycpu>
801042ea:	39 c3                	cmp    %eax,%ebx
801042ec:	0f 94 c0             	sete   %al
801042ef:	0f b6 c0             	movzbl %al,%eax
}
801042f2:	83 c4 04             	add    $0x4,%esp
801042f5:	5b                   	pop    %ebx
801042f6:	5d                   	pop    %ebp
801042f7:	c3                   	ret    
801042f8:	90                   	nop
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104300 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 04             	sub    $0x4,%esp
80104307:	9c                   	pushf  
80104308:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104309:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010430a:	e8 11 f3 ff ff       	call   80103620 <mycpu>
8010430f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104315:	85 c0                	test   %eax,%eax
80104317:	75 11                	jne    8010432a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104319:	e8 02 f3 ff ff       	call   80103620 <mycpu>
8010431e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104324:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010432a:	e8 f1 f2 ff ff       	call   80103620 <mycpu>
8010432f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104336:	83 c4 04             	add    $0x4,%esp
80104339:	5b                   	pop    %ebx
8010433a:	5d                   	pop    %ebp
8010433b:	c3                   	ret    
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104347:	e8 b4 ff ff ff       	call   80104300 <pushcli>
  if(holding(lk))
8010434c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010434f:	8b 02                	mov    (%edx),%eax
80104351:	85 c0                	test   %eax,%eax
80104353:	75 43                	jne    80104398 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104355:	b9 01 00 00 00       	mov    $0x1,%ecx
8010435a:	eb 07                	jmp    80104363 <acquire+0x23>
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104360:	8b 55 08             	mov    0x8(%ebp),%edx
80104363:	89 c8                	mov    %ecx,%eax
80104365:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104368:	85 c0                	test   %eax,%eax
8010436a:	75 f4                	jne    80104360 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010436c:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010436f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104372:	e8 a9 f2 ff ff       	call   80103620 <mycpu>
80104377:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010437a:	8b 45 08             	mov    0x8(%ebp),%eax
8010437d:	83 c0 0c             	add    $0xc,%eax
80104380:	89 44 24 04          	mov    %eax,0x4(%esp)
80104384:	8d 45 08             	lea    0x8(%ebp),%eax
80104387:	89 04 24             	mov    %eax,(%esp)
8010438a:	e8 e1 fe ff ff       	call   80104270 <getcallerpcs>
}
8010438f:	83 c4 14             	add    $0x14,%esp
80104392:	5b                   	pop    %ebx
80104393:	5d                   	pop    %ebp
80104394:	c3                   	ret    
80104395:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104398:	8b 5a 08             	mov    0x8(%edx),%ebx
8010439b:	e8 80 f2 ff ff       	call   80103620 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801043a0:	39 c3                	cmp    %eax,%ebx
801043a2:	74 05                	je     801043a9 <acquire+0x69>
801043a4:	8b 55 08             	mov    0x8(%ebp),%edx
801043a7:	eb ac                	jmp    80104355 <acquire+0x15>
    panic("acquire");
801043a9:	c7 04 24 43 75 10 80 	movl   $0x80107543,(%esp)
801043b0:	e8 ab bf ff ff       	call   80100360 <panic>
801043b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043c6:	9c                   	pushf  
801043c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043c8:	f6 c4 02             	test   $0x2,%ah
801043cb:	75 49                	jne    80104416 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801043cd:	e8 4e f2 ff ff       	call   80103620 <mycpu>
801043d2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801043d8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801043db:	85 d2                	test   %edx,%edx
801043dd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801043e3:	78 25                	js     8010440a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801043e5:	e8 36 f2 ff ff       	call   80103620 <mycpu>
801043ea:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801043f0:	85 d2                	test   %edx,%edx
801043f2:	74 04                	je     801043f8 <popcli+0x38>
    sti();
}
801043f4:	c9                   	leave  
801043f5:	c3                   	ret    
801043f6:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801043f8:	e8 23 f2 ff ff       	call   80103620 <mycpu>
801043fd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104403:	85 c0                	test   %eax,%eax
80104405:	74 ed                	je     801043f4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104407:	fb                   	sti    
    sti();
}
80104408:	c9                   	leave  
80104409:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010440a:	c7 04 24 62 75 10 80 	movl   $0x80107562,(%esp)
80104411:	e8 4a bf ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104416:	c7 04 24 4b 75 10 80 	movl   $0x8010754b,(%esp)
8010441d:	e8 3e bf ff ff       	call   80100360 <panic>
80104422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104430 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	83 ec 10             	sub    $0x10,%esp
80104438:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010443b:	8b 03                	mov    (%ebx),%eax
8010443d:	85 c0                	test   %eax,%eax
8010443f:	75 0f                	jne    80104450 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104441:	c7 04 24 69 75 10 80 	movl   $0x80107569,(%esp)
80104448:	e8 13 bf ff ff       	call   80100360 <panic>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104450:	8b 73 08             	mov    0x8(%ebx),%esi
80104453:	e8 c8 f1 ff ff       	call   80103620 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104458:	39 c6                	cmp    %eax,%esi
8010445a:	75 e5                	jne    80104441 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010445c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104463:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010446a:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010446d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	5b                   	pop    %ebx
80104477:	5e                   	pop    %esi
80104478:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104479:	e9 42 ff ff ff       	jmp    801043c0 <popcli>
8010447e:	66 90                	xchg   %ax,%ax

80104480 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	8b 55 08             	mov    0x8(%ebp),%edx
80104486:	57                   	push   %edi
80104487:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010448a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010448b:	f6 c2 03             	test   $0x3,%dl
8010448e:	75 05                	jne    80104495 <memset+0x15>
80104490:	f6 c1 03             	test   $0x3,%cl
80104493:	74 13                	je     801044a8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104495:	89 d7                	mov    %edx,%edi
80104497:	8b 45 0c             	mov    0xc(%ebp),%eax
8010449a:	fc                   	cld    
8010449b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010449d:	5b                   	pop    %ebx
8010449e:	89 d0                	mov    %edx,%eax
801044a0:	5f                   	pop    %edi
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801044ac:	c1 e9 02             	shr    $0x2,%ecx
801044af:	89 f8                	mov    %edi,%eax
801044b1:	89 fb                	mov    %edi,%ebx
801044b3:	c1 e0 18             	shl    $0x18,%eax
801044b6:	c1 e3 10             	shl    $0x10,%ebx
801044b9:	09 d8                	or     %ebx,%eax
801044bb:	09 f8                	or     %edi,%eax
801044bd:	c1 e7 08             	shl    $0x8,%edi
801044c0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044c2:	89 d7                	mov    %edx,%edi
801044c4:	fc                   	cld    
801044c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801044c7:	5b                   	pop    %ebx
801044c8:	89 d0                	mov    %edx,%eax
801044ca:	5f                   	pop    %edi
801044cb:	5d                   	pop    %ebp
801044cc:	c3                   	ret    
801044cd:	8d 76 00             	lea    0x0(%esi),%esi

801044d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	8b 45 10             	mov    0x10(%ebp),%eax
801044d6:	57                   	push   %edi
801044d7:	56                   	push   %esi
801044d8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044db:	53                   	push   %ebx
801044dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044df:	85 c0                	test   %eax,%eax
801044e1:	8d 78 ff             	lea    -0x1(%eax),%edi
801044e4:	74 26                	je     8010450c <memcmp+0x3c>
    if(*s1 != *s2)
801044e6:	0f b6 03             	movzbl (%ebx),%eax
801044e9:	31 d2                	xor    %edx,%edx
801044eb:	0f b6 0e             	movzbl (%esi),%ecx
801044ee:	38 c8                	cmp    %cl,%al
801044f0:	74 16                	je     80104508 <memcmp+0x38>
801044f2:	eb 24                	jmp    80104518 <memcmp+0x48>
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801044fd:	83 c2 01             	add    $0x1,%edx
80104500:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104504:	38 c8                	cmp    %cl,%al
80104506:	75 10                	jne    80104518 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104508:	39 fa                	cmp    %edi,%edx
8010450a:	75 ec                	jne    801044f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010450c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010450d:	31 c0                	xor    %eax,%eax
}
8010450f:	5e                   	pop    %esi
80104510:	5f                   	pop    %edi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret    
80104513:	90                   	nop
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104518:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104519:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010451b:	5e                   	pop    %esi
8010451c:	5f                   	pop    %edi
8010451d:	5d                   	pop    %ebp
8010451e:	c3                   	ret    
8010451f:	90                   	nop

80104520 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	8b 45 08             	mov    0x8(%ebp),%eax
80104527:	56                   	push   %esi
80104528:	8b 75 0c             	mov    0xc(%ebp),%esi
8010452b:	53                   	push   %ebx
8010452c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010452f:	39 c6                	cmp    %eax,%esi
80104531:	73 35                	jae    80104568 <memmove+0x48>
80104533:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104536:	39 c8                	cmp    %ecx,%eax
80104538:	73 2e                	jae    80104568 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010453a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010453c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010453f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104542:	74 1b                	je     8010455f <memmove+0x3f>
80104544:	f7 db                	neg    %ebx
80104546:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104549:	01 fb                	add    %edi,%ebx
8010454b:	90                   	nop
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104550:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104554:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104557:	83 ea 01             	sub    $0x1,%edx
8010455a:	83 fa ff             	cmp    $0xffffffff,%edx
8010455d:	75 f1                	jne    80104550 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010455f:	5b                   	pop    %ebx
80104560:	5e                   	pop    %esi
80104561:	5f                   	pop    %edi
80104562:	5d                   	pop    %ebp
80104563:	c3                   	ret    
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104568:	31 d2                	xor    %edx,%edx
8010456a:	85 db                	test   %ebx,%ebx
8010456c:	74 f1                	je     8010455f <memmove+0x3f>
8010456e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104570:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104574:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104577:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010457a:	39 da                	cmp    %ebx,%edx
8010457c:	75 f2                	jne    80104570 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010457e:	5b                   	pop    %ebx
8010457f:	5e                   	pop    %esi
80104580:	5f                   	pop    %edi
80104581:	5d                   	pop    %ebp
80104582:	c3                   	ret    
80104583:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104593:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104594:	e9 87 ff ff ff       	jmp    80104520 <memmove>
80104599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	8b 75 10             	mov    0x10(%ebp),%esi
801045a7:	53                   	push   %ebx
801045a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801045ae:	85 f6                	test   %esi,%esi
801045b0:	74 30                	je     801045e2 <strncmp+0x42>
801045b2:	0f b6 01             	movzbl (%ecx),%eax
801045b5:	84 c0                	test   %al,%al
801045b7:	74 2f                	je     801045e8 <strncmp+0x48>
801045b9:	0f b6 13             	movzbl (%ebx),%edx
801045bc:	38 d0                	cmp    %dl,%al
801045be:	75 46                	jne    80104606 <strncmp+0x66>
801045c0:	8d 51 01             	lea    0x1(%ecx),%edx
801045c3:	01 ce                	add    %ecx,%esi
801045c5:	eb 14                	jmp    801045db <strncmp+0x3b>
801045c7:	90                   	nop
801045c8:	0f b6 02             	movzbl (%edx),%eax
801045cb:	84 c0                	test   %al,%al
801045cd:	74 31                	je     80104600 <strncmp+0x60>
801045cf:	0f b6 19             	movzbl (%ecx),%ebx
801045d2:	83 c2 01             	add    $0x1,%edx
801045d5:	38 d8                	cmp    %bl,%al
801045d7:	75 17                	jne    801045f0 <strncmp+0x50>
    n--, p++, q++;
801045d9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045db:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801045dd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045e0:	75 e6                	jne    801045c8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045e2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801045e3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801045e5:	5e                   	pop    %esi
801045e6:	5d                   	pop    %ebp
801045e7:	c3                   	ret    
801045e8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045eb:	31 c0                	xor    %eax,%eax
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801045f0:	0f b6 d3             	movzbl %bl,%edx
801045f3:	29 d0                	sub    %edx,%eax
}
801045f5:	5b                   	pop    %ebx
801045f6:	5e                   	pop    %esi
801045f7:	5d                   	pop    %ebp
801045f8:	c3                   	ret    
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104600:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104604:	eb ea                	jmp    801045f0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104606:	89 d3                	mov    %edx,%ebx
80104608:	eb e6                	jmp    801045f0 <strncmp+0x50>
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104610 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	8b 45 08             	mov    0x8(%ebp),%eax
80104616:	56                   	push   %esi
80104617:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010461a:	53                   	push   %ebx
8010461b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010461e:	89 c2                	mov    %eax,%edx
80104620:	eb 19                	jmp    8010463b <strncpy+0x2b>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104628:	83 c3 01             	add    $0x1,%ebx
8010462b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010462f:	83 c2 01             	add    $0x1,%edx
80104632:	84 c9                	test   %cl,%cl
80104634:	88 4a ff             	mov    %cl,-0x1(%edx)
80104637:	74 09                	je     80104642 <strncpy+0x32>
80104639:	89 f1                	mov    %esi,%ecx
8010463b:	85 c9                	test   %ecx,%ecx
8010463d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104640:	7f e6                	jg     80104628 <strncpy+0x18>
    ;
  while(n-- > 0)
80104642:	31 c9                	xor    %ecx,%ecx
80104644:	85 f6                	test   %esi,%esi
80104646:	7e 0f                	jle    80104657 <strncpy+0x47>
    *s++ = 0;
80104648:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010464c:	89 f3                	mov    %esi,%ebx
8010464e:	83 c1 01             	add    $0x1,%ecx
80104651:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104653:	85 db                	test   %ebx,%ebx
80104655:	7f f1                	jg     80104648 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104657:	5b                   	pop    %ebx
80104658:	5e                   	pop    %esi
80104659:	5d                   	pop    %ebp
8010465a:	c3                   	ret    
8010465b:	90                   	nop
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104666:	56                   	push   %esi
80104667:	8b 45 08             	mov    0x8(%ebp),%eax
8010466a:	53                   	push   %ebx
8010466b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010466e:	85 c9                	test   %ecx,%ecx
80104670:	7e 26                	jle    80104698 <safestrcpy+0x38>
80104672:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104676:	89 c1                	mov    %eax,%ecx
80104678:	eb 17                	jmp    80104691 <safestrcpy+0x31>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104680:	83 c2 01             	add    $0x1,%edx
80104683:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104687:	83 c1 01             	add    $0x1,%ecx
8010468a:	84 db                	test   %bl,%bl
8010468c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010468f:	74 04                	je     80104695 <safestrcpy+0x35>
80104691:	39 f2                	cmp    %esi,%edx
80104693:	75 eb                	jne    80104680 <safestrcpy+0x20>
    ;
  *s = 0;
80104695:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104698:	5b                   	pop    %ebx
80104699:	5e                   	pop    %esi
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <strlen>:

int
strlen(const char *s)
{
801046a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046a1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801046a3:	89 e5                	mov    %esp,%ebp
801046a5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801046a8:	80 3a 00             	cmpb   $0x0,(%edx)
801046ab:	74 0c                	je     801046b9 <strlen+0x19>
801046ad:	8d 76 00             	lea    0x0(%esi),%esi
801046b0:	83 c0 01             	add    $0x1,%eax
801046b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046b7:	75 f7                	jne    801046b0 <strlen+0x10>
    ;
  return n;
}
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret    

801046bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801046c3:	55                   	push   %ebp
  pushl %ebx
801046c4:	53                   	push   %ebx
  pushl %esi
801046c5:	56                   	push   %esi
  pushl %edi
801046c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046c9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801046cb:	5f                   	pop    %edi
  popl %esi
801046cc:	5e                   	pop    %esi
  popl %ebx
801046cd:	5b                   	pop    %ebx
  popl %ebp
801046ce:	5d                   	pop    %ebp
  ret
801046cf:	c3                   	ret    

801046d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
801046d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801046da:	e8 e1 ef ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046df:	8b 00                	mov    (%eax),%eax
801046e1:	39 d8                	cmp    %ebx,%eax
801046e3:	76 1b                	jbe    80104700 <fetchint+0x30>
801046e5:	8d 53 04             	lea    0x4(%ebx),%edx
801046e8:	39 d0                	cmp    %edx,%eax
801046ea:	72 14                	jb     80104700 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801046ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801046ef:	8b 13                	mov    (%ebx),%edx
801046f1:	89 10                	mov    %edx,(%eax)
  return 0;
801046f3:	31 c0                	xor    %eax,%eax
}
801046f5:	83 c4 04             	add    $0x4,%esp
801046f8:	5b                   	pop    %ebx
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    
801046fb:	90                   	nop
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104705:	eb ee                	jmp    801046f5 <fetchint+0x25>
80104707:	89 f6                	mov    %esi,%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010471a:	e8 a1 ef ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz)
8010471f:	39 18                	cmp    %ebx,(%eax)
80104721:	76 26                	jbe    80104749 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104726:	89 da                	mov    %ebx,%edx
80104728:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010472a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010472c:	39 c3                	cmp    %eax,%ebx
8010472e:	73 19                	jae    80104749 <fetchstr+0x39>
    if(*s == 0)
80104730:	80 3b 00             	cmpb   $0x0,(%ebx)
80104733:	75 0d                	jne    80104742 <fetchstr+0x32>
80104735:	eb 21                	jmp    80104758 <fetchstr+0x48>
80104737:	90                   	nop
80104738:	80 3a 00             	cmpb   $0x0,(%edx)
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104740:	74 16                	je     80104758 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104742:	83 c2 01             	add    $0x1,%edx
80104745:	39 d0                	cmp    %edx,%eax
80104747:	77 ef                	ja     80104738 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104749:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010474c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104751:	5b                   	pop    %ebx
80104752:	5d                   	pop    %ebp
80104753:	c3                   	ret    
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104758:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
8010475b:	89 d0                	mov    %edx,%eax
8010475d:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
8010475f:	5b                   	pop    %ebx
80104760:	5d                   	pop    %ebp
80104761:	c3                   	ret    
80104762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	8b 75 0c             	mov    0xc(%ebp),%esi
80104777:	53                   	push   %ebx
80104778:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010477b:	e8 40 ef ff ff       	call   801036c0 <myproc>
80104780:	89 75 0c             	mov    %esi,0xc(%ebp)
80104783:	8b 40 18             	mov    0x18(%eax),%eax
80104786:	8b 40 44             	mov    0x44(%eax),%eax
80104789:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010478d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104790:	5b                   	pop    %ebx
80104791:	5e                   	pop    %esi
80104792:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104793:	e9 38 ff ff ff       	jmp    801046d0 <fetchint>
80104798:	90                   	nop
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	83 ec 20             	sub    $0x20,%esp
801047a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801047ab:	e8 10 ef ff ff       	call   801036c0 <myproc>
801047b0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801047b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801047b9:	8b 45 08             	mov    0x8(%ebp),%eax
801047bc:	89 04 24             	mov    %eax,(%esp)
801047bf:	e8 ac ff ff ff       	call   80104770 <argint>
801047c4:	85 c0                	test   %eax,%eax
801047c6:	78 28                	js     801047f0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801047c8:	85 db                	test   %ebx,%ebx
801047ca:	78 24                	js     801047f0 <argptr+0x50>
801047cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047cf:	8b 06                	mov    (%esi),%eax
801047d1:	39 c2                	cmp    %eax,%edx
801047d3:	73 1b                	jae    801047f0 <argptr+0x50>
801047d5:	01 d3                	add    %edx,%ebx
801047d7:	39 d8                	cmp    %ebx,%eax
801047d9:	72 15                	jb     801047f0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801047db:	8b 45 0c             	mov    0xc(%ebp),%eax
801047de:	89 10                	mov    %edx,(%eax)
  return 0;
}
801047e0:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
801047e3:	31 c0                	xor    %eax,%eax
}
801047e5:	5b                   	pop    %ebx
801047e6:	5e                   	pop    %esi
801047e7:	5d                   	pop    %ebp
801047e8:	c3                   	ret    
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f0:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
801047f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
801047f8:	5b                   	pop    %ebx
801047f9:	5e                   	pop    %esi
801047fa:	5d                   	pop    %ebp
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104806:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104809:	89 44 24 04          	mov    %eax,0x4(%esp)
8010480d:	8b 45 08             	mov    0x8(%ebp),%eax
80104810:	89 04 24             	mov    %eax,(%esp)
80104813:	e8 58 ff ff ff       	call   80104770 <argint>
80104818:	85 c0                	test   %eax,%eax
8010481a:	78 14                	js     80104830 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010481c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010481f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104826:	89 04 24             	mov    %eax,(%esp)
80104829:	e8 e2 fe ff ff       	call   80104710 <fetchstr>
}
8010482e:	c9                   	leave  
8010482f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104835:	c9                   	leave  
80104836:	c3                   	ret    
80104837:	89 f6                	mov    %esi,%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <syscall>:
[SYS_setpriority] sys_setpriority,
};

void
syscall(void)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104848:	e8 73 ee ff ff       	call   801036c0 <myproc>

  num = curproc->tf->eax;
8010484d:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104850:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104852:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104855:	8d 50 ff             	lea    -0x1(%eax),%edx
80104858:	83 fa 16             	cmp    $0x16,%edx
8010485b:	77 1b                	ja     80104878 <syscall+0x38>
8010485d:	8b 14 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%edx
80104864:	85 d2                	test   %edx,%edx
80104866:	74 10                	je     80104878 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104868:	ff d2                	call   *%edx
8010486a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010486d:	83 c4 10             	add    $0x10,%esp
80104870:	5b                   	pop    %ebx
80104871:	5e                   	pop    %esi
80104872:	5d                   	pop    %ebp
80104873:	c3                   	ret    
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104878:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010487c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010487f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104883:	8b 43 10             	mov    0x10(%ebx),%eax
80104886:	c7 04 24 71 75 10 80 	movl   $0x80107571,(%esp)
8010488d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104891:	e8 ba bd ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104896:	8b 43 18             	mov    0x18(%ebx),%eax
80104899:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048a0:	83 c4 10             	add    $0x10,%esp
801048a3:	5b                   	pop    %ebx
801048a4:	5e                   	pop    %esi
801048a5:	5d                   	pop    %ebp
801048a6:	c3                   	ret    
801048a7:	66 90                	xchg   %ax,%ax
801048a9:	66 90                	xchg   %ax,%ax
801048ab:	66 90                	xchg   %ax,%ax
801048ad:	66 90                	xchg   %ax,%ax
801048af:	90                   	nop

801048b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	89 c3                	mov    %eax,%ebx
801048b6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801048b9:	e8 02 ee ff ff       	call   801036c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801048be:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801048c0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801048c4:	85 c9                	test   %ecx,%ecx
801048c6:	74 18                	je     801048e0 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801048c8:	83 c2 01             	add    $0x1,%edx
801048cb:	83 fa 10             	cmp    $0x10,%edx
801048ce:	75 f0                	jne    801048c0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801048d0:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801048d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048d8:	5b                   	pop    %ebx
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	90                   	nop
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801048e0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
801048e4:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
801048e7:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
801048e9:	5b                   	pop    %ebx
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
801048f6:	83 ec 4c             	sub    $0x4c,%esp
801048f9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801048fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048ff:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104902:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104906:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104909:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010490c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010490f:	e8 1c d6 ff ff       	call   80101f30 <nameiparent>
80104914:	85 c0                	test   %eax,%eax
80104916:	89 c7                	mov    %eax,%edi
80104918:	0f 84 da 00 00 00    	je     801049f8 <create+0x108>
    return 0;
  ilock(dp);
8010491e:	89 04 24             	mov    %eax,(%esp)
80104921:	e8 9a cd ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104926:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104929:	89 44 24 08          	mov    %eax,0x8(%esp)
8010492d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104931:	89 3c 24             	mov    %edi,(%esp)
80104934:	e8 97 d2 ff ff       	call   80101bd0 <dirlookup>
80104939:	85 c0                	test   %eax,%eax
8010493b:	89 c6                	mov    %eax,%esi
8010493d:	74 41                	je     80104980 <create+0x90>
    iunlockput(dp);
8010493f:	89 3c 24             	mov    %edi,(%esp)
80104942:	e8 d9 cf ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104947:	89 34 24             	mov    %esi,(%esp)
8010494a:	e8 71 cd ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010494f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104954:	75 12                	jne    80104968 <create+0x78>
80104956:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010495b:	89 f0                	mov    %esi,%eax
8010495d:	75 09                	jne    80104968 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010495f:	83 c4 4c             	add    $0x4c,%esp
80104962:	5b                   	pop    %ebx
80104963:	5e                   	pop    %esi
80104964:	5f                   	pop    %edi
80104965:	5d                   	pop    %ebp
80104966:	c3                   	ret    
80104967:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104968:	89 34 24             	mov    %esi,(%esp)
8010496b:	e8 b0 cf ff ff       	call   80101920 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104970:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104973:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104975:	5b                   	pop    %ebx
80104976:	5e                   	pop    %esi
80104977:	5f                   	pop    %edi
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104980:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104984:	89 44 24 04          	mov    %eax,0x4(%esp)
80104988:	8b 07                	mov    (%edi),%eax
8010498a:	89 04 24             	mov    %eax,(%esp)
8010498d:	e8 9e cb ff ff       	call   80101530 <ialloc>
80104992:	85 c0                	test   %eax,%eax
80104994:	89 c6                	mov    %eax,%esi
80104996:	0f 84 bf 00 00 00    	je     80104a5b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010499c:	89 04 24             	mov    %eax,(%esp)
8010499f:	e8 1c cd ff ff       	call   801016c0 <ilock>
  ip->major = major;
801049a4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049a8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801049ac:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049b0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801049b4:	b8 01 00 00 00       	mov    $0x1,%eax
801049b9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801049bd:	89 34 24             	mov    %esi,(%esp)
801049c0:	e8 3b cc ff ff       	call   80101600 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801049c5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049ca:	74 34                	je     80104a00 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801049cc:	8b 46 04             	mov    0x4(%esi),%eax
801049cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801049d3:	89 3c 24             	mov    %edi,(%esp)
801049d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801049da:	e8 51 d4 ff ff       	call   80101e30 <dirlink>
801049df:	85 c0                	test   %eax,%eax
801049e1:	78 6c                	js     80104a4f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
801049e3:	89 3c 24             	mov    %edi,(%esp)
801049e6:	e8 35 cf ff ff       	call   80101920 <iunlockput>

  return ip;
}
801049eb:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801049ee:	89 f0                	mov    %esi,%eax
}
801049f0:	5b                   	pop    %ebx
801049f1:	5e                   	pop    %esi
801049f2:	5f                   	pop    %edi
801049f3:	5d                   	pop    %ebp
801049f4:	c3                   	ret    
801049f5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801049f8:	31 c0                	xor    %eax,%eax
801049fa:	e9 60 ff ff ff       	jmp    8010495f <create+0x6f>
801049ff:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a00:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a05:	89 3c 24             	mov    %edi,(%esp)
80104a08:	e8 f3 cb ff ff       	call   80101600 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a0d:	8b 46 04             	mov    0x4(%esi),%eax
80104a10:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80104a17:	80 
80104a18:	89 34 24             	mov    %esi,(%esp)
80104a1b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a1f:	e8 0c d4 ff ff       	call   80101e30 <dirlink>
80104a24:	85 c0                	test   %eax,%eax
80104a26:	78 1b                	js     80104a43 <create+0x153>
80104a28:	8b 47 04             	mov    0x4(%edi),%eax
80104a2b:	c7 44 24 04 1b 76 10 	movl   $0x8010761b,0x4(%esp)
80104a32:	80 
80104a33:	89 34 24             	mov    %esi,(%esp)
80104a36:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a3a:	e8 f1 d3 ff ff       	call   80101e30 <dirlink>
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	79 89                	jns    801049cc <create+0xdc>
      panic("create dots");
80104a43:	c7 04 24 0f 76 10 80 	movl   $0x8010760f,(%esp)
80104a4a:	e8 11 b9 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a4f:	c7 04 24 1e 76 10 80 	movl   $0x8010761e,(%esp)
80104a56:	e8 05 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104a5b:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80104a62:	e8 f9 b8 ff ff       	call   80100360 <panic>
80104a67:	89 f6                	mov    %esi,%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	89 c6                	mov    %eax,%esi
80104a76:	53                   	push   %ebx
80104a77:	89 d3                	mov    %edx,%ebx
80104a79:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a8a:	e8 e1 fc ff ff       	call   80104770 <argint>
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	78 2d                	js     80104ac0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a93:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a97:	77 27                	ja     80104ac0 <argfd.constprop.0+0x50>
80104a99:	e8 22 ec ff ff       	call   801036c0 <myproc>
80104a9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	74 17                	je     80104ac0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104aa9:	85 f6                	test   %esi,%esi
80104aab:	74 02                	je     80104aaf <argfd.constprop.0+0x3f>
    *pfd = fd;
80104aad:	89 16                	mov    %edx,(%esi)
  if(pf)
80104aaf:	85 db                	test   %ebx,%ebx
80104ab1:	74 1d                	je     80104ad0 <argfd.constprop.0+0x60>
    *pf = f;
80104ab3:	89 03                	mov    %eax,(%ebx)
  return 0;
80104ab5:	31 c0                	xor    %eax,%eax
}
80104ab7:	83 c4 20             	add    $0x20,%esp
80104aba:	5b                   	pop    %ebx
80104abb:	5e                   	pop    %esi
80104abc:	5d                   	pop    %ebp
80104abd:	c3                   	ret    
80104abe:	66 90                	xchg   %ax,%ax
80104ac0:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104ac8:	5b                   	pop    %ebx
80104ac9:	5e                   	pop    %esi
80104aca:	5d                   	pop    %ebp
80104acb:	c3                   	ret    
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ad0:	31 c0                	xor    %eax,%eax
80104ad2:	eb e3                	jmp    80104ab7 <argfd.constprop.0+0x47>
80104ad4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ada:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ae0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ae0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ae1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	53                   	push   %ebx
80104ae6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ae9:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104aec:	e8 7f ff ff ff       	call   80104a70 <argfd.constprop.0>
80104af1:	85 c0                	test   %eax,%eax
80104af3:	78 23                	js     80104b18 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	e8 b3 fd ff ff       	call   801048b0 <fdalloc>
80104afd:	85 c0                	test   %eax,%eax
80104aff:	89 c3                	mov    %eax,%ebx
80104b01:	78 15                	js     80104b18 <sys_dup+0x38>
    return -1;
  filedup(f);
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	89 04 24             	mov    %eax,(%esp)
80104b09:	e8 d2 c2 ff ff       	call   80100de0 <filedup>
  return fd;
80104b0e:	89 d8                	mov    %ebx,%eax
}
80104b10:	83 c4 24             	add    $0x24,%esp
80104b13:	5b                   	pop    %ebx
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    
80104b16:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b1d:	eb f1                	jmp    80104b10 <sys_dup+0x30>
80104b1f:	90                   	nop

80104b20 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104b20:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b21:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b2b:	e8 40 ff ff ff       	call   80104a70 <argfd.constprop.0>
80104b30:	85 c0                	test   %eax,%eax
80104b32:	78 54                	js     80104b88 <sys_read+0x68>
80104b34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b42:	e8 29 fc ff ff       	call   80104770 <argint>
80104b47:	85 c0                	test   %eax,%eax
80104b49:	78 3d                	js     80104b88 <sys_read+0x68>
80104b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b55:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b60:	e8 3b fc ff ff       	call   801047a0 <argptr>
80104b65:	85 c0                	test   %eax,%eax
80104b67:	78 1f                	js     80104b88 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b73:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b7a:	89 04 24             	mov    %eax,(%esp)
80104b7d:	e8 be c3 ff ff       	call   80100f40 <fileread>
}
80104b82:	c9                   	leave  
80104b83:	c3                   	ret    
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b8d:	c9                   	leave  
80104b8e:	c3                   	ret    
80104b8f:	90                   	nop

80104b90 <sys_write>:

int
sys_write(void)
{
80104b90:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b91:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b9b:	e8 d0 fe ff ff       	call   80104a70 <argfd.constprop.0>
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	78 54                	js     80104bf8 <sys_write+0x68>
80104ba4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bab:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104bb2:	e8 b9 fb ff ff       	call   80104770 <argint>
80104bb7:	85 c0                	test   %eax,%eax
80104bb9:	78 3d                	js     80104bf8 <sys_write+0x68>
80104bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bc5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bd0:	e8 cb fb ff ff       	call   801047a0 <argptr>
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	78 1f                	js     80104bf8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bdc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bea:	89 04 24             	mov    %eax,(%esp)
80104bed:	e8 ee c3 ff ff       	call   80100fe0 <filewrite>
}
80104bf2:	c9                   	leave  
80104bf3:	c3                   	ret    
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104bfd:	c9                   	leave  
80104bfe:	c3                   	ret    
80104bff:	90                   	nop

80104c00 <sys_close>:

int
sys_close(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c06:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c09:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c0c:	e8 5f fe ff ff       	call   80104a70 <argfd.constprop.0>
80104c11:	85 c0                	test   %eax,%eax
80104c13:	78 23                	js     80104c38 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104c15:	e8 a6 ea ff ff       	call   801036c0 <myproc>
80104c1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c1d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c24:	00 
  fileclose(f);
80104c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c28:	89 04 24             	mov    %eax,(%esp)
80104c2b:	e8 00 c2 ff ff       	call   80100e30 <fileclose>
  return 0;
80104c30:	31 c0                	xor    %eax,%eax
}
80104c32:	c9                   	leave  
80104c33:	c3                   	ret    
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c3d:	c9                   	leave  
80104c3e:	c3                   	ret    
80104c3f:	90                   	nop

80104c40 <sys_fstat>:

int
sys_fstat(void)
{
80104c40:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c41:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c4b:	e8 20 fe ff ff       	call   80104a70 <argfd.constprop.0>
80104c50:	85 c0                	test   %eax,%eax
80104c52:	78 34                	js     80104c88 <sys_fstat+0x48>
80104c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c57:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104c5e:	00 
80104c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c6a:	e8 31 fb ff ff       	call   801047a0 <argptr>
80104c6f:	85 c0                	test   %eax,%eax
80104c71:	78 15                	js     80104c88 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c76:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7d:	89 04 24             	mov    %eax,(%esp)
80104c80:	e8 6b c2 ff ff       	call   80100ef0 <filestat>
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104c8d:	c9                   	leave  
80104c8e:	c3                   	ret    
80104c8f:	90                   	nop

80104c90 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	53                   	push   %ebx
80104c96:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c99:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ca0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ca7:	e8 54 fb ff ff       	call   80104800 <argstr>
80104cac:	85 c0                	test   %eax,%eax
80104cae:	0f 88 e6 00 00 00    	js     80104d9a <sys_link+0x10a>
80104cb4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cc2:	e8 39 fb ff ff       	call   80104800 <argstr>
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	0f 88 cb 00 00 00    	js     80104d9a <sys_link+0x10a>
    return -1;

  begin_op();
80104ccf:	e8 4c de ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80104cd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104cd7:	89 04 24             	mov    %eax,(%esp)
80104cda:	e8 31 d2 ff ff       	call   80101f10 <namei>
80104cdf:	85 c0                	test   %eax,%eax
80104ce1:	89 c3                	mov    %eax,%ebx
80104ce3:	0f 84 ac 00 00 00    	je     80104d95 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104ce9:	89 04 24             	mov    %eax,(%esp)
80104cec:	e8 cf c9 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104cf1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cf6:	0f 84 91 00 00 00    	je     80104d8d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104cfc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d01:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d04:	89 1c 24             	mov    %ebx,(%esp)
80104d07:	e8 f4 c8 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104d0c:	89 1c 24             	mov    %ebx,(%esp)
80104d0f:	e8 8c ca ff ff       	call   801017a0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d14:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104d17:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d1b:	89 04 24             	mov    %eax,(%esp)
80104d1e:	e8 0d d2 ff ff       	call   80101f30 <nameiparent>
80104d23:	85 c0                	test   %eax,%eax
80104d25:	89 c6                	mov    %eax,%esi
80104d27:	74 4f                	je     80104d78 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104d29:	89 04 24             	mov    %eax,(%esp)
80104d2c:	e8 8f c9 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d31:	8b 03                	mov    (%ebx),%eax
80104d33:	39 06                	cmp    %eax,(%esi)
80104d35:	75 39                	jne    80104d70 <sys_link+0xe0>
80104d37:	8b 43 04             	mov    0x4(%ebx),%eax
80104d3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d3e:	89 34 24             	mov    %esi,(%esp)
80104d41:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d45:	e8 e6 d0 ff ff       	call   80101e30 <dirlink>
80104d4a:	85 c0                	test   %eax,%eax
80104d4c:	78 22                	js     80104d70 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104d4e:	89 34 24             	mov    %esi,(%esp)
80104d51:	e8 ca cb ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104d56:	89 1c 24             	mov    %ebx,(%esp)
80104d59:	e8 82 ca ff ff       	call   801017e0 <iput>

  end_op();
80104d5e:	e8 2d de ff ff       	call   80102b90 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d63:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104d66:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d68:	5b                   	pop    %ebx
80104d69:	5e                   	pop    %esi
80104d6a:	5f                   	pop    %edi
80104d6b:	5d                   	pop    %ebp
80104d6c:	c3                   	ret    
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104d70:	89 34 24             	mov    %esi,(%esp)
80104d73:	e8 a8 cb ff ff       	call   80101920 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104d78:	89 1c 24             	mov    %ebx,(%esp)
80104d7b:	e8 40 c9 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104d80:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d85:	89 1c 24             	mov    %ebx,(%esp)
80104d88:	e8 73 c8 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104d8d:	89 1c 24             	mov    %ebx,(%esp)
80104d90:	e8 8b cb ff ff       	call   80101920 <iunlockput>
  end_op();
80104d95:	e8 f6 dd ff ff       	call   80102b90 <end_op>
  return -1;
}
80104d9a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da2:	5b                   	pop    %ebx
80104da3:	5e                   	pop    %esi
80104da4:	5f                   	pop    %edi
80104da5:	5d                   	pop    %ebp
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	56                   	push   %esi
80104db5:	53                   	push   %ebx
80104db6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104db9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104dc7:	e8 34 fa ff ff       	call   80104800 <argstr>
80104dcc:	85 c0                	test   %eax,%eax
80104dce:	0f 88 76 01 00 00    	js     80104f4a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104dd4:	e8 47 dd ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104dd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104ddc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104ddf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104de3:	89 04 24             	mov    %eax,(%esp)
80104de6:	e8 45 d1 ff ff       	call   80101f30 <nameiparent>
80104deb:	85 c0                	test   %eax,%eax
80104ded:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104df0:	0f 84 4f 01 00 00    	je     80104f45 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104df6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104df9:	89 34 24             	mov    %esi,(%esp)
80104dfc:	e8 bf c8 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e01:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80104e08:	80 
80104e09:	89 1c 24             	mov    %ebx,(%esp)
80104e0c:	e8 8f cd ff ff       	call   80101ba0 <namecmp>
80104e11:	85 c0                	test   %eax,%eax
80104e13:	0f 84 21 01 00 00    	je     80104f3a <sys_unlink+0x18a>
80104e19:	c7 44 24 04 1b 76 10 	movl   $0x8010761b,0x4(%esp)
80104e20:	80 
80104e21:	89 1c 24             	mov    %ebx,(%esp)
80104e24:	e8 77 cd ff ff       	call   80101ba0 <namecmp>
80104e29:	85 c0                	test   %eax,%eax
80104e2b:	0f 84 09 01 00 00    	je     80104f3a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e31:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e38:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e3c:	89 34 24             	mov    %esi,(%esp)
80104e3f:	e8 8c cd ff ff       	call   80101bd0 <dirlookup>
80104e44:	85 c0                	test   %eax,%eax
80104e46:	89 c3                	mov    %eax,%ebx
80104e48:	0f 84 ec 00 00 00    	je     80104f3a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104e4e:	89 04 24             	mov    %eax,(%esp)
80104e51:	e8 6a c8 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
80104e56:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104e5b:	0f 8e 24 01 00 00    	jle    80104f85 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e66:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e69:	74 7d                	je     80104ee8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104e6b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104e72:	00 
80104e73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104e7a:	00 
80104e7b:	89 34 24             	mov    %esi,(%esp)
80104e7e:	e8 fd f5 ff ff       	call   80104480 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e83:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104e86:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e8d:	00 
80104e8e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e92:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e96:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e99:	89 04 24             	mov    %eax,(%esp)
80104e9c:	e8 cf cb ff ff       	call   80101a70 <writei>
80104ea1:	83 f8 10             	cmp    $0x10,%eax
80104ea4:	0f 85 cf 00 00 00    	jne    80104f79 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104eaa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eaf:	0f 84 a3 00 00 00    	je     80104f58 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104eb5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104eb8:	89 04 24             	mov    %eax,(%esp)
80104ebb:	e8 60 ca ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
80104ec0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ec5:	89 1c 24             	mov    %ebx,(%esp)
80104ec8:	e8 33 c7 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104ecd:	89 1c 24             	mov    %ebx,(%esp)
80104ed0:	e8 4b ca ff ff       	call   80101920 <iunlockput>

  end_op();
80104ed5:	e8 b6 dc ff ff       	call   80102b90 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104eda:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104edd:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104edf:	5b                   	pop    %ebx
80104ee0:	5e                   	pop    %esi
80104ee1:	5f                   	pop    %edi
80104ee2:	5d                   	pop    %ebp
80104ee3:	c3                   	ret    
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ee8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104eec:	0f 86 79 ff ff ff    	jbe    80104e6b <sys_unlink+0xbb>
80104ef2:	bf 20 00 00 00       	mov    $0x20,%edi
80104ef7:	eb 15                	jmp    80104f0e <sys_unlink+0x15e>
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f00:	8d 57 10             	lea    0x10(%edi),%edx
80104f03:	3b 53 58             	cmp    0x58(%ebx),%edx
80104f06:	0f 83 5f ff ff ff    	jae    80104e6b <sys_unlink+0xbb>
80104f0c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f0e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104f15:	00 
80104f16:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104f1a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104f1e:	89 1c 24             	mov    %ebx,(%esp)
80104f21:	e8 4a ca ff ff       	call   80101970 <readi>
80104f26:	83 f8 10             	cmp    $0x10,%eax
80104f29:	75 42                	jne    80104f6d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104f2b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f30:	74 ce                	je     80104f00 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104f32:	89 1c 24             	mov    %ebx,(%esp)
80104f35:	e8 e6 c9 ff ff       	call   80101920 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f3a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f3d:	89 04 24             	mov    %eax,(%esp)
80104f40:	e8 db c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104f45:	e8 46 dc ff ff       	call   80102b90 <end_op>
  return -1;
}
80104f4a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f52:	5b                   	pop    %ebx
80104f53:	5e                   	pop    %esi
80104f54:	5f                   	pop    %edi
80104f55:	5d                   	pop    %ebp
80104f56:	c3                   	ret    
80104f57:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f58:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f5b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f60:	89 04 24             	mov    %eax,(%esp)
80104f63:	e8 98 c6 ff ff       	call   80101600 <iupdate>
80104f68:	e9 48 ff ff ff       	jmp    80104eb5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104f6d:	c7 04 24 40 76 10 80 	movl   $0x80107640,(%esp)
80104f74:	e8 e7 b3 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104f79:	c7 04 24 52 76 10 80 	movl   $0x80107652,(%esp)
80104f80:	e8 db b3 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f85:	c7 04 24 2e 76 10 80 	movl   $0x8010762e,(%esp)
80104f8c:	e8 cf b3 ff ff       	call   80100360 <panic>
80104f91:	eb 0d                	jmp    80104fa0 <sys_open>
80104f93:	90                   	nop
80104f94:	90                   	nop
80104f95:	90                   	nop
80104f96:	90                   	nop
80104f97:	90                   	nop
80104f98:	90                   	nop
80104f99:	90                   	nop
80104f9a:	90                   	nop
80104f9b:	90                   	nop
80104f9c:	90                   	nop
80104f9d:	90                   	nop
80104f9e:	90                   	nop
80104f9f:	90                   	nop

80104fa0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	53                   	push   %ebx
80104fa6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104fa9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fb7:	e8 44 f8 ff ff       	call   80104800 <argstr>
80104fbc:	85 c0                	test   %eax,%eax
80104fbe:	0f 88 d1 00 00 00    	js     80105095 <sys_open+0xf5>
80104fc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fcb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fd2:	e8 99 f7 ff ff       	call   80104770 <argint>
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	0f 88 b6 00 00 00    	js     80105095 <sys_open+0xf5>
    return -1;

  begin_op();
80104fdf:	e8 3c db ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80104fe4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104fe8:	0f 85 82 00 00 00    	jne    80105070 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104fee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ff1:	89 04 24             	mov    %eax,(%esp)
80104ff4:	e8 17 cf ff ff       	call   80101f10 <namei>
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	89 c6                	mov    %eax,%esi
80104ffd:	0f 84 8d 00 00 00    	je     80105090 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80105003:	89 04 24             	mov    %eax,(%esp)
80105006:	e8 b5 c6 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010500b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105010:	0f 84 92 00 00 00    	je     801050a8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105016:	e8 55 bd ff ff       	call   80100d70 <filealloc>
8010501b:	85 c0                	test   %eax,%eax
8010501d:	89 c3                	mov    %eax,%ebx
8010501f:	0f 84 93 00 00 00    	je     801050b8 <sys_open+0x118>
80105025:	e8 86 f8 ff ff       	call   801048b0 <fdalloc>
8010502a:	85 c0                	test   %eax,%eax
8010502c:	89 c7                	mov    %eax,%edi
8010502e:	0f 88 94 00 00 00    	js     801050c8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105034:	89 34 24             	mov    %esi,(%esp)
80105037:	e8 64 c7 ff ff       	call   801017a0 <iunlock>
  end_op();
8010503c:	e8 4f db ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80105041:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010504a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010504d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105054:	89 c2                	mov    %eax,%edx
80105056:	83 e2 01             	and    $0x1,%edx
80105059:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010505c:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010505e:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80105061:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105063:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80105067:	83 c4 2c             	add    $0x2c,%esp
8010506a:	5b                   	pop    %ebx
8010506b:	5e                   	pop    %esi
8010506c:	5f                   	pop    %edi
8010506d:	5d                   	pop    %ebp
8010506e:	c3                   	ret    
8010506f:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105070:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105073:	31 c9                	xor    %ecx,%ecx
80105075:	ba 02 00 00 00       	mov    $0x2,%edx
8010507a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105081:	e8 6a f8 ff ff       	call   801048f0 <create>
    if(ip == 0){
80105086:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105088:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010508a:	75 8a                	jne    80105016 <sys_open+0x76>
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80105090:	e8 fb da ff ff       	call   80102b90 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105095:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010509d:	5b                   	pop    %ebx
8010509e:	5e                   	pop    %esi
8010509f:	5f                   	pop    %edi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret    
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801050a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801050ab:	85 c0                	test   %eax,%eax
801050ad:	0f 84 63 ff ff ff    	je     80105016 <sys_open+0x76>
801050b3:	90                   	nop
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
801050b8:	89 34 24             	mov    %esi,(%esp)
801050bb:	e8 60 c8 ff ff       	call   80101920 <iunlockput>
801050c0:	eb ce                	jmp    80105090 <sys_open+0xf0>
801050c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801050c8:	89 1c 24             	mov    %ebx,(%esp)
801050cb:	e8 60 bd ff ff       	call   80100e30 <fileclose>
801050d0:	eb e6                	jmp    801050b8 <sys_open+0x118>
801050d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050e6:	e8 35 da ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801050eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050f9:	e8 02 f7 ff ff       	call   80104800 <argstr>
801050fe:	85 c0                	test   %eax,%eax
80105100:	78 2e                	js     80105130 <sys_mkdir+0x50>
80105102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105105:	31 c9                	xor    %ecx,%ecx
80105107:	ba 01 00 00 00       	mov    $0x1,%edx
8010510c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105113:	e8 d8 f7 ff ff       	call   801048f0 <create>
80105118:	85 c0                	test   %eax,%eax
8010511a:	74 14                	je     80105130 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010511c:	89 04 24             	mov    %eax,(%esp)
8010511f:	e8 fc c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105124:	e8 67 da ff ff       	call   80102b90 <end_op>
  return 0;
80105129:	31 c0                	xor    %eax,%eax
}
8010512b:	c9                   	leave  
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105130:	e8 5b da ff ff       	call   80102b90 <end_op>
    return -1;
80105135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <sys_mknod>:

int
sys_mknod(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105146:	e8 d5 d9 ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010514b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010514e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105159:	e8 a2 f6 ff ff       	call   80104800 <argstr>
8010515e:	85 c0                	test   %eax,%eax
80105160:	78 5e                	js     801051c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105162:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105165:	89 44 24 04          	mov    %eax,0x4(%esp)
80105169:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105170:	e8 fb f5 ff ff       	call   80104770 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105175:	85 c0                	test   %eax,%eax
80105177:	78 47                	js     801051c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105179:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010517c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105180:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105187:	e8 e4 f5 ff ff       	call   80104770 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010518c:	85 c0                	test   %eax,%eax
8010518e:	78 30                	js     801051c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105190:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105194:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105199:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010519d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801051a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051a3:	e8 48 f7 ff ff       	call   801048f0 <create>
801051a8:	85 c0                	test   %eax,%eax
801051aa:	74 14                	je     801051c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801051ac:	89 04 24             	mov    %eax,(%esp)
801051af:	e8 6c c7 ff ff       	call   80101920 <iunlockput>
  end_op();
801051b4:	e8 d7 d9 ff ff       	call   80102b90 <end_op>
  return 0;
801051b9:	31 c0                	xor    %eax,%eax
}
801051bb:	c9                   	leave  
801051bc:	c3                   	ret    
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801051c0:	e8 cb d9 ff ff       	call   80102b90 <end_op>
    return -1;
801051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051ca:	c9                   	leave  
801051cb:	c3                   	ret    
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_chdir>:

int
sys_chdir(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801051d8:	e8 e3 e4 ff ff       	call   801036c0 <myproc>
801051dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801051df:	e8 3c d9 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801051e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801051eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051f2:	e8 09 f6 ff ff       	call   80104800 <argstr>
801051f7:	85 c0                	test   %eax,%eax
801051f9:	78 4a                	js     80105245 <sys_chdir+0x75>
801051fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051fe:	89 04 24             	mov    %eax,(%esp)
80105201:	e8 0a cd ff ff       	call   80101f10 <namei>
80105206:	85 c0                	test   %eax,%eax
80105208:	89 c3                	mov    %eax,%ebx
8010520a:	74 39                	je     80105245 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010520c:	89 04 24             	mov    %eax,(%esp)
8010520f:	e8 ac c4 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105214:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105219:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010521c:	75 22                	jne    80105240 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010521e:	e8 7d c5 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105223:	8b 46 68             	mov    0x68(%esi),%eax
80105226:	89 04 24             	mov    %eax,(%esp)
80105229:	e8 b2 c5 ff ff       	call   801017e0 <iput>
  end_op();
8010522e:	e8 5d d9 ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
80105233:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105235:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
80105238:	83 c4 20             	add    $0x20,%esp
8010523b:	5b                   	pop    %ebx
8010523c:	5e                   	pop    %esi
8010523d:	5d                   	pop    %ebp
8010523e:	c3                   	ret    
8010523f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105240:	e8 db c6 ff ff       	call   80101920 <iunlockput>
    end_op();
80105245:	e8 46 d9 ff ff       	call   80102b90 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010524a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010524d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80105252:	5b                   	pop    %ebx
80105253:	5e                   	pop    %esi
80105254:	5d                   	pop    %ebp
80105255:	c3                   	ret    
80105256:	8d 76 00             	lea    0x0(%esi),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_exec>:

int
sys_exec(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	53                   	push   %ebx
80105266:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010526c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105272:	89 44 24 04          	mov    %eax,0x4(%esp)
80105276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010527d:	e8 7e f5 ff ff       	call   80104800 <argstr>
80105282:	85 c0                	test   %eax,%eax
80105284:	0f 88 84 00 00 00    	js     8010530e <sys_exec+0xae>
8010528a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105290:	89 44 24 04          	mov    %eax,0x4(%esp)
80105294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010529b:	e8 d0 f4 ff ff       	call   80104770 <argint>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 6a                	js     8010530e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052a4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801052aa:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052ac:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801052b3:	00 
801052b4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801052ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801052c1:	00 
801052c2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801052c8:	89 04 24             	mov    %eax,(%esp)
801052cb:	e8 b0 f1 ff ff       	call   80104480 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801052d0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801052d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801052da:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801052dd:	89 04 24             	mov    %eax,(%esp)
801052e0:	e8 eb f3 ff ff       	call   801046d0 <fetchint>
801052e5:	85 c0                	test   %eax,%eax
801052e7:	78 25                	js     8010530e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801052e9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801052ef:	85 c0                	test   %eax,%eax
801052f1:	74 2d                	je     80105320 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801052f3:	89 74 24 04          	mov    %esi,0x4(%esp)
801052f7:	89 04 24             	mov    %eax,(%esp)
801052fa:	e8 11 f4 ff ff       	call   80104710 <fetchstr>
801052ff:	85 c0                	test   %eax,%eax
80105301:	78 0b                	js     8010530e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105303:	83 c3 01             	add    $0x1,%ebx
80105306:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105309:	83 fb 20             	cmp    $0x20,%ebx
8010530c:	75 c2                	jne    801052d0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010530e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105320:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105326:	89 44 24 04          	mov    %eax,0x4(%esp)
8010532a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105330:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105337:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010533b:	89 04 24             	mov    %eax,(%esp)
8010533e:	e8 5d b6 ff ff       	call   801009a0 <exec>
}
80105343:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105349:	5b                   	pop    %ebx
8010534a:	5e                   	pop    %esi
8010534b:	5f                   	pop    %edi
8010534c:	5d                   	pop    %ebp
8010534d:	c3                   	ret    
8010534e:	66 90                	xchg   %ax,%ax

80105350 <sys_pipe>:

int
sys_pipe(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	53                   	push   %ebx
80105354:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105357:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010535a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105361:	00 
80105362:	89 44 24 04          	mov    %eax,0x4(%esp)
80105366:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010536d:	e8 2e f4 ff ff       	call   801047a0 <argptr>
80105372:	85 c0                	test   %eax,%eax
80105374:	78 6d                	js     801053e3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105376:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105379:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105380:	89 04 24             	mov    %eax,(%esp)
80105383:	e8 f8 dd ff ff       	call   80103180 <pipealloc>
80105388:	85 c0                	test   %eax,%eax
8010538a:	78 57                	js     801053e3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010538c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538f:	e8 1c f5 ff ff       	call   801048b0 <fdalloc>
80105394:	85 c0                	test   %eax,%eax
80105396:	89 c3                	mov    %eax,%ebx
80105398:	78 33                	js     801053cd <sys_pipe+0x7d>
8010539a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539d:	e8 0e f5 ff ff       	call   801048b0 <fdalloc>
801053a2:	85 c0                	test   %eax,%eax
801053a4:	78 1a                	js     801053c0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801053a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053a9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801053ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053ae:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801053b1:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801053b4:	31 c0                	xor    %eax,%eax
}
801053b6:	5b                   	pop    %ebx
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801053c0:	e8 fb e2 ff ff       	call   801036c0 <myproc>
801053c5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801053cc:	00 
    fileclose(rf);
801053cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d0:	89 04 24             	mov    %eax,(%esp)
801053d3:	e8 58 ba ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801053d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053db:	89 04 24             	mov    %eax,(%esp)
801053de:	e8 4d ba ff ff       	call   80100e30 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053e3:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801053e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053eb:	5b                   	pop    %ebx
801053ec:	5d                   	pop    %ebp
801053ed:	c3                   	ret    
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801053f3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801053f4:	e9 77 e4 ff ff       	jmp    80103870 <fork>
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_exit>:
}

int
sys_exit(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 28             	sub    $0x28,%esp
  int status;
  argint(0, &status);
80105406:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010540d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105414:	e8 57 f3 ff ff       	call   80104770 <argint>
  exit(status);
80105419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010541c:	89 04 24             	mov    %eax,(%esp)
8010541f:	e8 2c e7 ff ff       	call   80103b50 <exit>
  return 0;  // not reached
}
80105424:	31 c0                	xor    %eax,%eax
80105426:	c9                   	leave  
80105427:	c3                   	ret    
80105428:	90                   	nop
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_wait>:

int
sys_wait(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 28             	sub    $0x28,%esp
  int *status;
  argptr(0, (char**)&status, sizeof(&status));
80105436:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105439:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105440:	00 
80105441:	89 44 24 04          	mov    %eax,0x4(%esp)
80105445:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010544c:	e8 4f f3 ff ff       	call   801047a0 <argptr>
  return wait(status);
80105451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105454:	89 04 24             	mov    %eax,(%esp)
80105457:	e8 24 e9 ff ff       	call   80103d80 <wait>
//  return 0;
}
8010545c:	c9                   	leave  
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax

80105460 <sys_waitpid>:

int
sys_waitpid(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 28             	sub    $0x28,%esp
  int pid;
  int *status;
  int options;

  argint(0, &pid);
80105466:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105469:	89 44 24 04          	mov    %eax,0x4(%esp)
8010546d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105474:	e8 f7 f2 ff ff       	call   80104770 <argint>
  argptr(1, (char**)&status, sizeof(int*));
80105479:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105483:	00 
80105484:	89 44 24 04          	mov    %eax,0x4(%esp)
80105488:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010548f:	e8 0c f3 ff ff       	call   801047a0 <argptr>
  argint(2, &options);
80105494:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105497:	89 44 24 04          	mov    %eax,0x4(%esp)
8010549b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054a2:	e8 c9 f2 ff ff       	call   80104770 <argint>
  return  waitpid(pid, status, options);
801054a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801054ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054b8:	89 04 24             	mov    %eax,(%esp)
801054bb:	e8 b0 e9 ff ff       	call   80103e70 <waitpid>
 

}
801054c0:	c9                   	leave  
801054c1:	c3                   	ret    
801054c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <sys_kill>:

int
sys_kill(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801054d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801054dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054e4:	e8 87 f2 ff ff       	call   80104770 <argint>
801054e9:	85 c0                	test   %eax,%eax
801054eb:	78 13                	js     80105500 <sys_kill+0x30>
    return -1;
  return kill(pid);
801054ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f0:	89 04 24             	mov    %eax,(%esp)
801054f3:	e8 d8 ea ff ff       	call   80103fd0 <kill>
}
801054f8:	c9                   	leave  
801054f9:	c3                   	ret    
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <sys_getpid>:

int
sys_getpid(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105516:	e8 a5 e1 ff ff       	call   801036c0 <myproc>
8010551b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010551e:	c9                   	leave  
8010551f:	c3                   	ret    

80105520 <sys_sbrk>:

int
sys_sbrk(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	53                   	push   %ebx
80105524:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105527:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010552a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010552e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105535:	e8 36 f2 ff ff       	call   80104770 <argint>
8010553a:	85 c0                	test   %eax,%eax
8010553c:	78 22                	js     80105560 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010553e:	e8 7d e1 ff ff       	call   801036c0 <myproc>
  if(growproc(n) < 0)
80105543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105546:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105548:	89 14 24             	mov    %edx,(%esp)
8010554b:	e8 b0 e2 ff ff       	call   80103800 <growproc>
80105550:	85 c0                	test   %eax,%eax
80105552:	78 0c                	js     80105560 <sys_sbrk+0x40>
    return -1;
  return addr;
80105554:	89 d8                	mov    %ebx,%eax
}
80105556:	83 c4 24             	add    $0x24,%esp
80105559:	5b                   	pop    %ebx
8010555a:	5d                   	pop    %ebp
8010555b:	c3                   	ret    
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	eb ef                	jmp    80105556 <sys_sbrk+0x36>
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
80105574:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105577:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010557e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105585:	e8 e6 f1 ff ff       	call   80104770 <argint>
8010558a:	85 c0                	test   %eax,%eax
8010558c:	78 7e                	js     8010560c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010558e:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105595:	e8 a6 ed ff ff       	call   80104340 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010559a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010559d:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
801055a3:	85 d2                	test   %edx,%edx
801055a5:	75 29                	jne    801055d0 <sys_sleep+0x60>
801055a7:	eb 4f                	jmp    801055f8 <sys_sleep+0x88>
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801055b0:	c7 44 24 04 60 50 11 	movl   $0x80115060,0x4(%esp)
801055b7:	80 
801055b8:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
801055bf:	e8 0c e7 ff ff       	call   80103cd0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055c4:	a1 a0 58 11 80       	mov    0x801158a0,%eax
801055c9:	29 d8                	sub    %ebx,%eax
801055cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801055ce:	73 28                	jae    801055f8 <sys_sleep+0x88>
    if(myproc()->killed){
801055d0:	e8 eb e0 ff ff       	call   801036c0 <myproc>
801055d5:	8b 40 24             	mov    0x24(%eax),%eax
801055d8:	85 c0                	test   %eax,%eax
801055da:	74 d4                	je     801055b0 <sys_sleep+0x40>
      release(&tickslock);
801055dc:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801055e3:	e8 48 ee ff ff       	call   80104430 <release>
      return -1;
801055e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801055ed:	83 c4 24             	add    $0x24,%esp
801055f0:	5b                   	pop    %ebx
801055f1:	5d                   	pop    %ebp
801055f2:	c3                   	ret    
801055f3:	90                   	nop
801055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801055f8:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801055ff:	e8 2c ee ff ff       	call   80104430 <release>
  return 0;
}
80105604:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105607:	31 c0                	xor    %eax,%eax
}
80105609:	5b                   	pop    %ebx
8010560a:	5d                   	pop    %ebp
8010560b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010560c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105611:	eb da                	jmp    801055ed <sys_sleep+0x7d>
80105613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	53                   	push   %ebx
80105624:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105627:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
8010562e:	e8 0d ed ff ff       	call   80104340 <acquire>
  xticks = ticks;
80105633:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
80105639:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105640:	e8 eb ed ff ff       	call   80104430 <release>
  return xticks;
}
80105645:	83 c4 14             	add    $0x14,%esp
80105648:	89 d8                	mov    %ebx,%eax
8010564a:	5b                   	pop    %ebx
8010564b:	5d                   	pop    %ebp
8010564c:	c3                   	ret    
8010564d:	8d 76 00             	lea    0x0(%esi),%esi

80105650 <sys_setpriority>:

/* THIS PIECE OF CODE IS ADDED TO SWITCH THE PRIORITY
OF A PROCESS
*/
void
sys_setpriority(void){
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 28             	sub    $0x28,%esp
  int prio;
    argint(0, &prio);
80105656:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105659:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105664:	e8 07 f1 ff ff       	call   80104770 <argint>

    setpriority(prio);
80105669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566c:	89 04 24             	mov    %eax,(%esp)
8010566f:	e8 ac ea ff ff       	call   80104120 <setpriority>


}
80105674:	c9                   	leave  
80105675:	c3                   	ret    

80105676 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105676:	1e                   	push   %ds
  pushl %es
80105677:	06                   	push   %es
  pushl %fs
80105678:	0f a0                	push   %fs
  pushl %gs
8010567a:	0f a8                	push   %gs
  pushal
8010567c:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010567d:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105681:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105683:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105685:	54                   	push   %esp
  call trap
80105686:	e8 e5 00 00 00       	call   80105770 <trap>
  addl $4, %esp
8010568b:	83 c4 04             	add    $0x4,%esp

8010568e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010568e:	61                   	popa   
  popl %gs
8010568f:	0f a9                	pop    %gs
  popl %fs
80105691:	0f a1                	pop    %fs
  popl %es
80105693:	07                   	pop    %es
  popl %ds
80105694:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105695:	83 c4 08             	add    $0x8,%esp
  iret
80105698:	cf                   	iret   
80105699:	66 90                	xchg   %ax,%ax
8010569b:	66 90                	xchg   %ax,%ax
8010569d:	66 90                	xchg   %ax,%ax
8010569f:	90                   	nop

801056a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056a0:	31 c0                	xor    %eax,%eax
801056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056a8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801056af:	b9 08 00 00 00       	mov    $0x8,%ecx
801056b4:	66 89 0c c5 a2 50 11 	mov    %cx,-0x7feeaf5e(,%eax,8)
801056bb:	80 
801056bc:	c6 04 c5 a4 50 11 80 	movb   $0x0,-0x7feeaf5c(,%eax,8)
801056c3:	00 
801056c4:	c6 04 c5 a5 50 11 80 	movb   $0x8e,-0x7feeaf5b(,%eax,8)
801056cb:	8e 
801056cc:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
801056d3:	80 
801056d4:	c1 ea 10             	shr    $0x10,%edx
801056d7:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
801056de:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056df:	83 c0 01             	add    $0x1,%eax
801056e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801056e7:	75 bf                	jne    801056a8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056e9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056ea:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056ef:	89 e5                	mov    %esp,%ebp
801056f1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056f4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801056f9:	c7 44 24 04 61 76 10 	movl   $0x80107661,0x4(%esp)
80105700:	80 
80105701:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105708:	66 89 15 a2 52 11 80 	mov    %dx,0x801152a2
8010570f:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80105715:	c1 e8 10             	shr    $0x10,%eax
80105718:	c6 05 a4 52 11 80 00 	movb   $0x0,0x801152a4
8010571f:	c6 05 a5 52 11 80 ef 	movb   $0xef,0x801152a5
80105726:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6

  initlock(&tickslock, "time");
8010572c:	e8 1f eb ff ff       	call   80104250 <initlock>
}
80105731:	c9                   	leave  
80105732:	c3                   	ret    
80105733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <idtinit>:

void
idtinit(void)
{
80105740:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105741:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105746:	89 e5                	mov    %esp,%ebp
80105748:	83 ec 10             	sub    $0x10,%esp
8010574b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010574f:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
80105754:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105758:	c1 e8 10             	shr    $0x10,%eax
8010575b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010575f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105762:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
80105776:	83 ec 3c             	sub    $0x3c,%esp
80105779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010577c:	8b 43 30             	mov    0x30(%ebx),%eax
8010577f:	83 f8 40             	cmp    $0x40,%eax
80105782:	0f 84 a0 01 00 00    	je     80105928 <trap+0x1b8>
    if(myproc()->killed)
      exit(0);
    return;
  }

  switch(tf->trapno){
80105788:	83 e8 20             	sub    $0x20,%eax
8010578b:	83 f8 1f             	cmp    $0x1f,%eax
8010578e:	77 08                	ja     80105798 <trap+0x28>
80105790:	ff 24 85 08 77 10 80 	jmp    *-0x7fef88f8(,%eax,4)
80105797:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105798:	e8 23 df ff ff       	call   801036c0 <myproc>
8010579d:	85 c0                	test   %eax,%eax
8010579f:	90                   	nop
801057a0:	0f 84 0a 02 00 00    	je     801059b0 <trap+0x240>
801057a6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801057aa:	0f 84 00 02 00 00    	je     801059b0 <trap+0x240>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057b0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057b3:	8b 53 38             	mov    0x38(%ebx),%edx
801057b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801057b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
801057bc:	e8 df de ff ff       	call   801036a0 <cpuid>
801057c1:	8b 73 30             	mov    0x30(%ebx),%esi
801057c4:	89 c7                	mov    %eax,%edi
801057c6:	8b 43 34             	mov    0x34(%ebx),%eax
801057c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057cc:	e8 ef de ff ff       	call   801036c0 <myproc>
801057d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801057d4:	e8 e7 de ff ff       	call   801036c0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801057dc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057e0:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057e3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801057e6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801057ea:	89 54 24 18          	mov    %edx,0x18(%esp)
801057ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057f1:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057f4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057f8:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057fc:	89 54 24 10          	mov    %edx,0x10(%esp)
80105800:	8b 40 10             	mov    0x10(%eax),%eax
80105803:	c7 04 24 c4 76 10 80 	movl   $0x801076c4,(%esp)
8010580a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010580e:	e8 3d ae ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105813:	e8 a8 de ff ff       	call   801036c0 <myproc>
80105818:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010581f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105820:	e8 9b de ff ff       	call   801036c0 <myproc>
80105825:	85 c0                	test   %eax,%eax
80105827:	74 0c                	je     80105835 <trap+0xc5>
80105829:	e8 92 de ff ff       	call   801036c0 <myproc>
8010582e:	8b 50 24             	mov    0x24(%eax),%edx
80105831:	85 d2                	test   %edx,%edx
80105833:	75 4b                	jne    80105880 <trap+0x110>
    exit(0);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105835:	e8 86 de ff ff       	call   801036c0 <myproc>
8010583a:	85 c0                	test   %eax,%eax
8010583c:	74 0d                	je     8010584b <trap+0xdb>
8010583e:	66 90                	xchg   %ax,%ax
80105840:	e8 7b de ff ff       	call   801036c0 <myproc>
80105845:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105849:	74 55                	je     801058a0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010584b:	e8 70 de ff ff       	call   801036c0 <myproc>
80105850:	85 c0                	test   %eax,%eax
80105852:	74 1d                	je     80105871 <trap+0x101>
80105854:	e8 67 de ff ff       	call   801036c0 <myproc>
80105859:	8b 40 24             	mov    0x24(%eax),%eax
8010585c:	85 c0                	test   %eax,%eax
8010585e:	74 11                	je     80105871 <trap+0x101>
80105860:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105864:	83 e0 03             	and    $0x3,%eax
80105867:	66 83 f8 03          	cmp    $0x3,%ax
8010586b:	0f 84 e8 00 00 00    	je     80105959 <trap+0x1e9>
    exit(0);
}
80105871:	83 c4 3c             	add    $0x3c,%esp
80105874:	5b                   	pop    %ebx
80105875:	5e                   	pop    %esi
80105876:	5f                   	pop    %edi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105880:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105884:	83 e0 03             	and    $0x3,%eax
80105887:	66 83 f8 03          	cmp    $0x3,%ax
8010588b:	75 a8                	jne    80105835 <trap+0xc5>
    exit(0);
8010588d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105894:	e8 b7 e2 ff ff       	call   80103b50 <exit>
80105899:	eb 9a                	jmp    80105835 <trap+0xc5>
8010589b:	90                   	nop
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801058a4:	75 a5                	jne    8010584b <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801058a6:	e8 e5 e3 ff ff       	call   80103c90 <yield>
801058ab:	eb 9e                	jmp    8010584b <trap+0xdb>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801058b0:	e8 eb dd ff ff       	call   801036a0 <cpuid>
801058b5:	85 c0                	test   %eax,%eax
801058b7:	0f 84 c3 00 00 00    	je     80105980 <trap+0x210>
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801058c0:	e8 cb ce ff ff       	call   80102790 <lapiceoi>
    break;
801058c5:	e9 56 ff ff ff       	jmp    80105820 <trap+0xb0>
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801058d0:	e8 0b cd ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
801058d5:	e8 b6 ce ff ff       	call   80102790 <lapiceoi>
    break;
801058da:	e9 41 ff ff ff       	jmp    80105820 <trap+0xb0>
801058df:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801058e0:	e8 2b 02 00 00       	call   80105b10 <uartintr>
    lapiceoi();
801058e5:	e8 a6 ce ff ff       	call   80102790 <lapiceoi>
    break;
801058ea:	e9 31 ff ff ff       	jmp    80105820 <trap+0xb0>
801058ef:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058f0:	8b 7b 38             	mov    0x38(%ebx),%edi
801058f3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801058f7:	e8 a4 dd ff ff       	call   801036a0 <cpuid>
801058fc:	c7 04 24 6c 76 10 80 	movl   $0x8010766c,(%esp)
80105903:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105907:	89 74 24 08          	mov    %esi,0x8(%esp)
8010590b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010590f:	e8 3c ad ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105914:	e8 77 ce ff ff       	call   80102790 <lapiceoi>
    break;
80105919:	e9 02 ff ff ff       	jmp    80105820 <trap+0xb0>
8010591e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105920:	e8 6b c7 ff ff       	call   80102090 <ideintr>
80105925:	eb 96                	jmp    801058bd <trap+0x14d>
80105927:	90                   	nop
80105928:	90                   	nop
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105930:	e8 8b dd ff ff       	call   801036c0 <myproc>
80105935:	8b 70 24             	mov    0x24(%eax),%esi
80105938:	85 f6                	test   %esi,%esi
8010593a:	75 34                	jne    80105970 <trap+0x200>
      exit(0);
    myproc()->tf = tf;
8010593c:	e8 7f dd ff ff       	call   801036c0 <myproc>
80105941:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105944:	e8 f7 ee ff ff       	call   80104840 <syscall>
    if(myproc()->killed)
80105949:	e8 72 dd ff ff       	call   801036c0 <myproc>
8010594e:	8b 48 24             	mov    0x24(%eax),%ecx
80105951:	85 c9                	test   %ecx,%ecx
80105953:	0f 84 18 ff ff ff    	je     80105871 <trap+0x101>
      exit(0);
80105959:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit(0);
}
80105960:	83 c4 3c             	add    $0x3c,%esp
80105963:	5b                   	pop    %ebx
80105964:	5e                   	pop    %esi
80105965:	5f                   	pop    %edi
80105966:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit(0);
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit(0);
80105967:	e9 e4 e1 ff ff       	jmp    80103b50 <exit>
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit(0);
80105970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105977:	e8 d4 e1 ff ff       	call   80103b50 <exit>
8010597c:	eb be                	jmp    8010593c <trap+0x1cc>
8010597e:	66 90                	xchg   %ax,%ax
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105980:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105987:	e8 b4 e9 ff ff       	call   80104340 <acquire>
      ticks++;
      wakeup(&ticks);
8010598c:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105993:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
8010599a:	e8 c1 e5 ff ff       	call   80103f60 <wakeup>
      release(&tickslock);
8010599f:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801059a6:	e8 85 ea ff ff       	call   80104430 <release>
801059ab:	e9 0d ff ff ff       	jmp    801058bd <trap+0x14d>
801059b0:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059b3:	8b 73 38             	mov    0x38(%ebx),%esi
801059b6:	e8 e5 dc ff ff       	call   801036a0 <cpuid>
801059bb:	89 7c 24 10          	mov    %edi,0x10(%esp)
801059bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
801059c3:	89 44 24 08          	mov    %eax,0x8(%esp)
801059c7:	8b 43 30             	mov    0x30(%ebx),%eax
801059ca:	c7 04 24 90 76 10 80 	movl   $0x80107690,(%esp)
801059d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801059d5:	e8 76 ac ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801059da:	c7 04 24 66 76 10 80 	movl   $0x80107666,(%esp)
801059e1:	e8 7a a9 ff ff       	call   80100360 <panic>
801059e6:	66 90                	xchg   %ax,%ax
801059e8:	66 90                	xchg   %ax,%ax
801059ea:	66 90                	xchg   %ax,%ax
801059ec:	66 90                	xchg   %ax,%ax
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059f8:	85 c0                	test   %eax,%eax
801059fa:	74 14                	je     80105a10 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a02:	a8 01                	test   $0x1,%al
80105a04:	74 0a                	je     80105a10 <uartgetc+0x20>
80105a06:	b2 f8                	mov    $0xf8,%dl
80105a08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a09:	0f b6 c0             	movzbl %al,%eax
}
80105a0c:	5d                   	pop    %ebp
80105a0d:	c3                   	ret    
80105a0e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a15:	5d                   	pop    %ebp
80105a16:	c3                   	ret    
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a20 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105a20:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105a25:	85 c0                	test   %eax,%eax
80105a27:	74 3f                	je     80105a68 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105a29:	55                   	push   %ebp
80105a2a:	89 e5                	mov    %esp,%ebp
80105a2c:	56                   	push   %esi
80105a2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a32:	53                   	push   %ebx
  int i;

  if(!uart)
80105a33:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105a38:	83 ec 10             	sub    $0x10,%esp
80105a3b:	eb 14                	jmp    80105a51 <uartputc+0x31>
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a40:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105a47:	e8 64 cd ff ff       	call   801027b0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a4c:	83 eb 01             	sub    $0x1,%ebx
80105a4f:	74 07                	je     80105a58 <uartputc+0x38>
80105a51:	89 f2                	mov    %esi,%edx
80105a53:	ec                   	in     (%dx),%al
80105a54:	a8 20                	test   $0x20,%al
80105a56:	74 e8                	je     80105a40 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105a58:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a5c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a61:	ee                   	out    %al,(%dx)
}
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	5b                   	pop    %ebx
80105a66:	5e                   	pop    %esi
80105a67:	5d                   	pop    %ebp
80105a68:	f3 c3                	repz ret 
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a70 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a70:	55                   	push   %ebp
80105a71:	31 c9                	xor    %ecx,%ecx
80105a73:	89 e5                	mov    %esp,%ebp
80105a75:	89 c8                	mov    %ecx,%eax
80105a77:	57                   	push   %edi
80105a78:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105a7d:	56                   	push   %esi
80105a7e:	89 fa                	mov    %edi,%edx
80105a80:	53                   	push   %ebx
80105a81:	83 ec 1c             	sub    $0x1c,%esp
80105a84:	ee                   	out    %al,(%dx)
80105a85:	be fb 03 00 00       	mov    $0x3fb,%esi
80105a8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a8f:	89 f2                	mov    %esi,%edx
80105a91:	ee                   	out    %al,(%dx)
80105a92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a97:	b2 f8                	mov    $0xf8,%dl
80105a99:	ee                   	out    %al,(%dx)
80105a9a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105a9f:	89 c8                	mov    %ecx,%eax
80105aa1:	89 da                	mov    %ebx,%edx
80105aa3:	ee                   	out    %al,(%dx)
80105aa4:	b8 03 00 00 00       	mov    $0x3,%eax
80105aa9:	89 f2                	mov    %esi,%edx
80105aab:	ee                   	out    %al,(%dx)
80105aac:	b2 fc                	mov    $0xfc,%dl
80105aae:	89 c8                	mov    %ecx,%eax
80105ab0:	ee                   	out    %al,(%dx)
80105ab1:	b8 01 00 00 00       	mov    $0x1,%eax
80105ab6:	89 da                	mov    %ebx,%edx
80105ab8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ab9:	b2 fd                	mov    $0xfd,%dl
80105abb:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105abc:	3c ff                	cmp    $0xff,%al
80105abe:	74 42                	je     80105b02 <uartinit+0x92>
    return;
  uart = 1;
80105ac0:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ac7:	00 00 00 
80105aca:	89 fa                	mov    %edi,%edx
80105acc:	ec                   	in     (%dx),%al
80105acd:	b2 f8                	mov    $0xf8,%dl
80105acf:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105ad0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ad7:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ad8:	bb 88 77 10 80       	mov    $0x80107788,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105add:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105ae4:	e8 d7 c7 ff ff       	call   801022c0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ae9:	b8 78 00 00 00       	mov    $0x78,%eax
80105aee:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105af0:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105af3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105af6:	e8 25 ff ff ff       	call   80105a20 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105afb:	0f be 03             	movsbl (%ebx),%eax
80105afe:	84 c0                	test   %al,%al
80105b00:	75 ee                	jne    80105af0 <uartinit+0x80>
    uartputc(*p);
}
80105b02:	83 c4 1c             	add    $0x1c,%esp
80105b05:	5b                   	pop    %ebx
80105b06:	5e                   	pop    %esi
80105b07:	5f                   	pop    %edi
80105b08:	5d                   	pop    %ebp
80105b09:	c3                   	ret    
80105b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b10 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105b16:	c7 04 24 f0 59 10 80 	movl   $0x801059f0,(%esp)
80105b1d:	e8 8e ac ff ff       	call   801007b0 <consoleintr>
}
80105b22:	c9                   	leave  
80105b23:	c3                   	ret    

80105b24 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $0
80105b26:	6a 00                	push   $0x0
  jmp alltraps
80105b28:	e9 49 fb ff ff       	jmp    80105676 <alltraps>

80105b2d <vector1>:
.globl vector1
vector1:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $1
80105b2f:	6a 01                	push   $0x1
  jmp alltraps
80105b31:	e9 40 fb ff ff       	jmp    80105676 <alltraps>

80105b36 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $2
80105b38:	6a 02                	push   $0x2
  jmp alltraps
80105b3a:	e9 37 fb ff ff       	jmp    80105676 <alltraps>

80105b3f <vector3>:
.globl vector3
vector3:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $3
80105b41:	6a 03                	push   $0x3
  jmp alltraps
80105b43:	e9 2e fb ff ff       	jmp    80105676 <alltraps>

80105b48 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $4
80105b4a:	6a 04                	push   $0x4
  jmp alltraps
80105b4c:	e9 25 fb ff ff       	jmp    80105676 <alltraps>

80105b51 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $5
80105b53:	6a 05                	push   $0x5
  jmp alltraps
80105b55:	e9 1c fb ff ff       	jmp    80105676 <alltraps>

80105b5a <vector6>:
.globl vector6
vector6:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $6
80105b5c:	6a 06                	push   $0x6
  jmp alltraps
80105b5e:	e9 13 fb ff ff       	jmp    80105676 <alltraps>

80105b63 <vector7>:
.globl vector7
vector7:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $7
80105b65:	6a 07                	push   $0x7
  jmp alltraps
80105b67:	e9 0a fb ff ff       	jmp    80105676 <alltraps>

80105b6c <vector8>:
.globl vector8
vector8:
  pushl $8
80105b6c:	6a 08                	push   $0x8
  jmp alltraps
80105b6e:	e9 03 fb ff ff       	jmp    80105676 <alltraps>

80105b73 <vector9>:
.globl vector9
vector9:
  pushl $0
80105b73:	6a 00                	push   $0x0
  pushl $9
80105b75:	6a 09                	push   $0x9
  jmp alltraps
80105b77:	e9 fa fa ff ff       	jmp    80105676 <alltraps>

80105b7c <vector10>:
.globl vector10
vector10:
  pushl $10
80105b7c:	6a 0a                	push   $0xa
  jmp alltraps
80105b7e:	e9 f3 fa ff ff       	jmp    80105676 <alltraps>

80105b83 <vector11>:
.globl vector11
vector11:
  pushl $11
80105b83:	6a 0b                	push   $0xb
  jmp alltraps
80105b85:	e9 ec fa ff ff       	jmp    80105676 <alltraps>

80105b8a <vector12>:
.globl vector12
vector12:
  pushl $12
80105b8a:	6a 0c                	push   $0xc
  jmp alltraps
80105b8c:	e9 e5 fa ff ff       	jmp    80105676 <alltraps>

80105b91 <vector13>:
.globl vector13
vector13:
  pushl $13
80105b91:	6a 0d                	push   $0xd
  jmp alltraps
80105b93:	e9 de fa ff ff       	jmp    80105676 <alltraps>

80105b98 <vector14>:
.globl vector14
vector14:
  pushl $14
80105b98:	6a 0e                	push   $0xe
  jmp alltraps
80105b9a:	e9 d7 fa ff ff       	jmp    80105676 <alltraps>

80105b9f <vector15>:
.globl vector15
vector15:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $15
80105ba1:	6a 0f                	push   $0xf
  jmp alltraps
80105ba3:	e9 ce fa ff ff       	jmp    80105676 <alltraps>

80105ba8 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ba8:	6a 00                	push   $0x0
  pushl $16
80105baa:	6a 10                	push   $0x10
  jmp alltraps
80105bac:	e9 c5 fa ff ff       	jmp    80105676 <alltraps>

80105bb1 <vector17>:
.globl vector17
vector17:
  pushl $17
80105bb1:	6a 11                	push   $0x11
  jmp alltraps
80105bb3:	e9 be fa ff ff       	jmp    80105676 <alltraps>

80105bb8 <vector18>:
.globl vector18
vector18:
  pushl $0
80105bb8:	6a 00                	push   $0x0
  pushl $18
80105bba:	6a 12                	push   $0x12
  jmp alltraps
80105bbc:	e9 b5 fa ff ff       	jmp    80105676 <alltraps>

80105bc1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105bc1:	6a 00                	push   $0x0
  pushl $19
80105bc3:	6a 13                	push   $0x13
  jmp alltraps
80105bc5:	e9 ac fa ff ff       	jmp    80105676 <alltraps>

80105bca <vector20>:
.globl vector20
vector20:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $20
80105bcc:	6a 14                	push   $0x14
  jmp alltraps
80105bce:	e9 a3 fa ff ff       	jmp    80105676 <alltraps>

80105bd3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $21
80105bd5:	6a 15                	push   $0x15
  jmp alltraps
80105bd7:	e9 9a fa ff ff       	jmp    80105676 <alltraps>

80105bdc <vector22>:
.globl vector22
vector22:
  pushl $0
80105bdc:	6a 00                	push   $0x0
  pushl $22
80105bde:	6a 16                	push   $0x16
  jmp alltraps
80105be0:	e9 91 fa ff ff       	jmp    80105676 <alltraps>

80105be5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105be5:	6a 00                	push   $0x0
  pushl $23
80105be7:	6a 17                	push   $0x17
  jmp alltraps
80105be9:	e9 88 fa ff ff       	jmp    80105676 <alltraps>

80105bee <vector24>:
.globl vector24
vector24:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $24
80105bf0:	6a 18                	push   $0x18
  jmp alltraps
80105bf2:	e9 7f fa ff ff       	jmp    80105676 <alltraps>

80105bf7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105bf7:	6a 00                	push   $0x0
  pushl $25
80105bf9:	6a 19                	push   $0x19
  jmp alltraps
80105bfb:	e9 76 fa ff ff       	jmp    80105676 <alltraps>

80105c00 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c00:	6a 00                	push   $0x0
  pushl $26
80105c02:	6a 1a                	push   $0x1a
  jmp alltraps
80105c04:	e9 6d fa ff ff       	jmp    80105676 <alltraps>

80105c09 <vector27>:
.globl vector27
vector27:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $27
80105c0b:	6a 1b                	push   $0x1b
  jmp alltraps
80105c0d:	e9 64 fa ff ff       	jmp    80105676 <alltraps>

80105c12 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $28
80105c14:	6a 1c                	push   $0x1c
  jmp alltraps
80105c16:	e9 5b fa ff ff       	jmp    80105676 <alltraps>

80105c1b <vector29>:
.globl vector29
vector29:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $29
80105c1d:	6a 1d                	push   $0x1d
  jmp alltraps
80105c1f:	e9 52 fa ff ff       	jmp    80105676 <alltraps>

80105c24 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $30
80105c26:	6a 1e                	push   $0x1e
  jmp alltraps
80105c28:	e9 49 fa ff ff       	jmp    80105676 <alltraps>

80105c2d <vector31>:
.globl vector31
vector31:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $31
80105c2f:	6a 1f                	push   $0x1f
  jmp alltraps
80105c31:	e9 40 fa ff ff       	jmp    80105676 <alltraps>

80105c36 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $32
80105c38:	6a 20                	push   $0x20
  jmp alltraps
80105c3a:	e9 37 fa ff ff       	jmp    80105676 <alltraps>

80105c3f <vector33>:
.globl vector33
vector33:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $33
80105c41:	6a 21                	push   $0x21
  jmp alltraps
80105c43:	e9 2e fa ff ff       	jmp    80105676 <alltraps>

80105c48 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c48:	6a 00                	push   $0x0
  pushl $34
80105c4a:	6a 22                	push   $0x22
  jmp alltraps
80105c4c:	e9 25 fa ff ff       	jmp    80105676 <alltraps>

80105c51 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $35
80105c53:	6a 23                	push   $0x23
  jmp alltraps
80105c55:	e9 1c fa ff ff       	jmp    80105676 <alltraps>

80105c5a <vector36>:
.globl vector36
vector36:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $36
80105c5c:	6a 24                	push   $0x24
  jmp alltraps
80105c5e:	e9 13 fa ff ff       	jmp    80105676 <alltraps>

80105c63 <vector37>:
.globl vector37
vector37:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $37
80105c65:	6a 25                	push   $0x25
  jmp alltraps
80105c67:	e9 0a fa ff ff       	jmp    80105676 <alltraps>

80105c6c <vector38>:
.globl vector38
vector38:
  pushl $0
80105c6c:	6a 00                	push   $0x0
  pushl $38
80105c6e:	6a 26                	push   $0x26
  jmp alltraps
80105c70:	e9 01 fa ff ff       	jmp    80105676 <alltraps>

80105c75 <vector39>:
.globl vector39
vector39:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $39
80105c77:	6a 27                	push   $0x27
  jmp alltraps
80105c79:	e9 f8 f9 ff ff       	jmp    80105676 <alltraps>

80105c7e <vector40>:
.globl vector40
vector40:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $40
80105c80:	6a 28                	push   $0x28
  jmp alltraps
80105c82:	e9 ef f9 ff ff       	jmp    80105676 <alltraps>

80105c87 <vector41>:
.globl vector41
vector41:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $41
80105c89:	6a 29                	push   $0x29
  jmp alltraps
80105c8b:	e9 e6 f9 ff ff       	jmp    80105676 <alltraps>

80105c90 <vector42>:
.globl vector42
vector42:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $42
80105c92:	6a 2a                	push   $0x2a
  jmp alltraps
80105c94:	e9 dd f9 ff ff       	jmp    80105676 <alltraps>

80105c99 <vector43>:
.globl vector43
vector43:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $43
80105c9b:	6a 2b                	push   $0x2b
  jmp alltraps
80105c9d:	e9 d4 f9 ff ff       	jmp    80105676 <alltraps>

80105ca2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $44
80105ca4:	6a 2c                	push   $0x2c
  jmp alltraps
80105ca6:	e9 cb f9 ff ff       	jmp    80105676 <alltraps>

80105cab <vector45>:
.globl vector45
vector45:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $45
80105cad:	6a 2d                	push   $0x2d
  jmp alltraps
80105caf:	e9 c2 f9 ff ff       	jmp    80105676 <alltraps>

80105cb4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $46
80105cb6:	6a 2e                	push   $0x2e
  jmp alltraps
80105cb8:	e9 b9 f9 ff ff       	jmp    80105676 <alltraps>

80105cbd <vector47>:
.globl vector47
vector47:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $47
80105cbf:	6a 2f                	push   $0x2f
  jmp alltraps
80105cc1:	e9 b0 f9 ff ff       	jmp    80105676 <alltraps>

80105cc6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $48
80105cc8:	6a 30                	push   $0x30
  jmp alltraps
80105cca:	e9 a7 f9 ff ff       	jmp    80105676 <alltraps>

80105ccf <vector49>:
.globl vector49
vector49:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $49
80105cd1:	6a 31                	push   $0x31
  jmp alltraps
80105cd3:	e9 9e f9 ff ff       	jmp    80105676 <alltraps>

80105cd8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $50
80105cda:	6a 32                	push   $0x32
  jmp alltraps
80105cdc:	e9 95 f9 ff ff       	jmp    80105676 <alltraps>

80105ce1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $51
80105ce3:	6a 33                	push   $0x33
  jmp alltraps
80105ce5:	e9 8c f9 ff ff       	jmp    80105676 <alltraps>

80105cea <vector52>:
.globl vector52
vector52:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $52
80105cec:	6a 34                	push   $0x34
  jmp alltraps
80105cee:	e9 83 f9 ff ff       	jmp    80105676 <alltraps>

80105cf3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $53
80105cf5:	6a 35                	push   $0x35
  jmp alltraps
80105cf7:	e9 7a f9 ff ff       	jmp    80105676 <alltraps>

80105cfc <vector54>:
.globl vector54
vector54:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $54
80105cfe:	6a 36                	push   $0x36
  jmp alltraps
80105d00:	e9 71 f9 ff ff       	jmp    80105676 <alltraps>

80105d05 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $55
80105d07:	6a 37                	push   $0x37
  jmp alltraps
80105d09:	e9 68 f9 ff ff       	jmp    80105676 <alltraps>

80105d0e <vector56>:
.globl vector56
vector56:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $56
80105d10:	6a 38                	push   $0x38
  jmp alltraps
80105d12:	e9 5f f9 ff ff       	jmp    80105676 <alltraps>

80105d17 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $57
80105d19:	6a 39                	push   $0x39
  jmp alltraps
80105d1b:	e9 56 f9 ff ff       	jmp    80105676 <alltraps>

80105d20 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $58
80105d22:	6a 3a                	push   $0x3a
  jmp alltraps
80105d24:	e9 4d f9 ff ff       	jmp    80105676 <alltraps>

80105d29 <vector59>:
.globl vector59
vector59:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $59
80105d2b:	6a 3b                	push   $0x3b
  jmp alltraps
80105d2d:	e9 44 f9 ff ff       	jmp    80105676 <alltraps>

80105d32 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $60
80105d34:	6a 3c                	push   $0x3c
  jmp alltraps
80105d36:	e9 3b f9 ff ff       	jmp    80105676 <alltraps>

80105d3b <vector61>:
.globl vector61
vector61:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $61
80105d3d:	6a 3d                	push   $0x3d
  jmp alltraps
80105d3f:	e9 32 f9 ff ff       	jmp    80105676 <alltraps>

80105d44 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $62
80105d46:	6a 3e                	push   $0x3e
  jmp alltraps
80105d48:	e9 29 f9 ff ff       	jmp    80105676 <alltraps>

80105d4d <vector63>:
.globl vector63
vector63:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $63
80105d4f:	6a 3f                	push   $0x3f
  jmp alltraps
80105d51:	e9 20 f9 ff ff       	jmp    80105676 <alltraps>

80105d56 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $64
80105d58:	6a 40                	push   $0x40
  jmp alltraps
80105d5a:	e9 17 f9 ff ff       	jmp    80105676 <alltraps>

80105d5f <vector65>:
.globl vector65
vector65:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $65
80105d61:	6a 41                	push   $0x41
  jmp alltraps
80105d63:	e9 0e f9 ff ff       	jmp    80105676 <alltraps>

80105d68 <vector66>:
.globl vector66
vector66:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $66
80105d6a:	6a 42                	push   $0x42
  jmp alltraps
80105d6c:	e9 05 f9 ff ff       	jmp    80105676 <alltraps>

80105d71 <vector67>:
.globl vector67
vector67:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $67
80105d73:	6a 43                	push   $0x43
  jmp alltraps
80105d75:	e9 fc f8 ff ff       	jmp    80105676 <alltraps>

80105d7a <vector68>:
.globl vector68
vector68:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $68
80105d7c:	6a 44                	push   $0x44
  jmp alltraps
80105d7e:	e9 f3 f8 ff ff       	jmp    80105676 <alltraps>

80105d83 <vector69>:
.globl vector69
vector69:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $69
80105d85:	6a 45                	push   $0x45
  jmp alltraps
80105d87:	e9 ea f8 ff ff       	jmp    80105676 <alltraps>

80105d8c <vector70>:
.globl vector70
vector70:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $70
80105d8e:	6a 46                	push   $0x46
  jmp alltraps
80105d90:	e9 e1 f8 ff ff       	jmp    80105676 <alltraps>

80105d95 <vector71>:
.globl vector71
vector71:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $71
80105d97:	6a 47                	push   $0x47
  jmp alltraps
80105d99:	e9 d8 f8 ff ff       	jmp    80105676 <alltraps>

80105d9e <vector72>:
.globl vector72
vector72:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $72
80105da0:	6a 48                	push   $0x48
  jmp alltraps
80105da2:	e9 cf f8 ff ff       	jmp    80105676 <alltraps>

80105da7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $73
80105da9:	6a 49                	push   $0x49
  jmp alltraps
80105dab:	e9 c6 f8 ff ff       	jmp    80105676 <alltraps>

80105db0 <vector74>:
.globl vector74
vector74:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $74
80105db2:	6a 4a                	push   $0x4a
  jmp alltraps
80105db4:	e9 bd f8 ff ff       	jmp    80105676 <alltraps>

80105db9 <vector75>:
.globl vector75
vector75:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $75
80105dbb:	6a 4b                	push   $0x4b
  jmp alltraps
80105dbd:	e9 b4 f8 ff ff       	jmp    80105676 <alltraps>

80105dc2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $76
80105dc4:	6a 4c                	push   $0x4c
  jmp alltraps
80105dc6:	e9 ab f8 ff ff       	jmp    80105676 <alltraps>

80105dcb <vector77>:
.globl vector77
vector77:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $77
80105dcd:	6a 4d                	push   $0x4d
  jmp alltraps
80105dcf:	e9 a2 f8 ff ff       	jmp    80105676 <alltraps>

80105dd4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $78
80105dd6:	6a 4e                	push   $0x4e
  jmp alltraps
80105dd8:	e9 99 f8 ff ff       	jmp    80105676 <alltraps>

80105ddd <vector79>:
.globl vector79
vector79:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $79
80105ddf:	6a 4f                	push   $0x4f
  jmp alltraps
80105de1:	e9 90 f8 ff ff       	jmp    80105676 <alltraps>

80105de6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $80
80105de8:	6a 50                	push   $0x50
  jmp alltraps
80105dea:	e9 87 f8 ff ff       	jmp    80105676 <alltraps>

80105def <vector81>:
.globl vector81
vector81:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $81
80105df1:	6a 51                	push   $0x51
  jmp alltraps
80105df3:	e9 7e f8 ff ff       	jmp    80105676 <alltraps>

80105df8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $82
80105dfa:	6a 52                	push   $0x52
  jmp alltraps
80105dfc:	e9 75 f8 ff ff       	jmp    80105676 <alltraps>

80105e01 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $83
80105e03:	6a 53                	push   $0x53
  jmp alltraps
80105e05:	e9 6c f8 ff ff       	jmp    80105676 <alltraps>

80105e0a <vector84>:
.globl vector84
vector84:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $84
80105e0c:	6a 54                	push   $0x54
  jmp alltraps
80105e0e:	e9 63 f8 ff ff       	jmp    80105676 <alltraps>

80105e13 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $85
80105e15:	6a 55                	push   $0x55
  jmp alltraps
80105e17:	e9 5a f8 ff ff       	jmp    80105676 <alltraps>

80105e1c <vector86>:
.globl vector86
vector86:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $86
80105e1e:	6a 56                	push   $0x56
  jmp alltraps
80105e20:	e9 51 f8 ff ff       	jmp    80105676 <alltraps>

80105e25 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $87
80105e27:	6a 57                	push   $0x57
  jmp alltraps
80105e29:	e9 48 f8 ff ff       	jmp    80105676 <alltraps>

80105e2e <vector88>:
.globl vector88
vector88:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $88
80105e30:	6a 58                	push   $0x58
  jmp alltraps
80105e32:	e9 3f f8 ff ff       	jmp    80105676 <alltraps>

80105e37 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $89
80105e39:	6a 59                	push   $0x59
  jmp alltraps
80105e3b:	e9 36 f8 ff ff       	jmp    80105676 <alltraps>

80105e40 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $90
80105e42:	6a 5a                	push   $0x5a
  jmp alltraps
80105e44:	e9 2d f8 ff ff       	jmp    80105676 <alltraps>

80105e49 <vector91>:
.globl vector91
vector91:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $91
80105e4b:	6a 5b                	push   $0x5b
  jmp alltraps
80105e4d:	e9 24 f8 ff ff       	jmp    80105676 <alltraps>

80105e52 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $92
80105e54:	6a 5c                	push   $0x5c
  jmp alltraps
80105e56:	e9 1b f8 ff ff       	jmp    80105676 <alltraps>

80105e5b <vector93>:
.globl vector93
vector93:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $93
80105e5d:	6a 5d                	push   $0x5d
  jmp alltraps
80105e5f:	e9 12 f8 ff ff       	jmp    80105676 <alltraps>

80105e64 <vector94>:
.globl vector94
vector94:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $94
80105e66:	6a 5e                	push   $0x5e
  jmp alltraps
80105e68:	e9 09 f8 ff ff       	jmp    80105676 <alltraps>

80105e6d <vector95>:
.globl vector95
vector95:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $95
80105e6f:	6a 5f                	push   $0x5f
  jmp alltraps
80105e71:	e9 00 f8 ff ff       	jmp    80105676 <alltraps>

80105e76 <vector96>:
.globl vector96
vector96:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $96
80105e78:	6a 60                	push   $0x60
  jmp alltraps
80105e7a:	e9 f7 f7 ff ff       	jmp    80105676 <alltraps>

80105e7f <vector97>:
.globl vector97
vector97:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $97
80105e81:	6a 61                	push   $0x61
  jmp alltraps
80105e83:	e9 ee f7 ff ff       	jmp    80105676 <alltraps>

80105e88 <vector98>:
.globl vector98
vector98:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $98
80105e8a:	6a 62                	push   $0x62
  jmp alltraps
80105e8c:	e9 e5 f7 ff ff       	jmp    80105676 <alltraps>

80105e91 <vector99>:
.globl vector99
vector99:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $99
80105e93:	6a 63                	push   $0x63
  jmp alltraps
80105e95:	e9 dc f7 ff ff       	jmp    80105676 <alltraps>

80105e9a <vector100>:
.globl vector100
vector100:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $100
80105e9c:	6a 64                	push   $0x64
  jmp alltraps
80105e9e:	e9 d3 f7 ff ff       	jmp    80105676 <alltraps>

80105ea3 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $101
80105ea5:	6a 65                	push   $0x65
  jmp alltraps
80105ea7:	e9 ca f7 ff ff       	jmp    80105676 <alltraps>

80105eac <vector102>:
.globl vector102
vector102:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $102
80105eae:	6a 66                	push   $0x66
  jmp alltraps
80105eb0:	e9 c1 f7 ff ff       	jmp    80105676 <alltraps>

80105eb5 <vector103>:
.globl vector103
vector103:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $103
80105eb7:	6a 67                	push   $0x67
  jmp alltraps
80105eb9:	e9 b8 f7 ff ff       	jmp    80105676 <alltraps>

80105ebe <vector104>:
.globl vector104
vector104:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $104
80105ec0:	6a 68                	push   $0x68
  jmp alltraps
80105ec2:	e9 af f7 ff ff       	jmp    80105676 <alltraps>

80105ec7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $105
80105ec9:	6a 69                	push   $0x69
  jmp alltraps
80105ecb:	e9 a6 f7 ff ff       	jmp    80105676 <alltraps>

80105ed0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $106
80105ed2:	6a 6a                	push   $0x6a
  jmp alltraps
80105ed4:	e9 9d f7 ff ff       	jmp    80105676 <alltraps>

80105ed9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $107
80105edb:	6a 6b                	push   $0x6b
  jmp alltraps
80105edd:	e9 94 f7 ff ff       	jmp    80105676 <alltraps>

80105ee2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $108
80105ee4:	6a 6c                	push   $0x6c
  jmp alltraps
80105ee6:	e9 8b f7 ff ff       	jmp    80105676 <alltraps>

80105eeb <vector109>:
.globl vector109
vector109:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $109
80105eed:	6a 6d                	push   $0x6d
  jmp alltraps
80105eef:	e9 82 f7 ff ff       	jmp    80105676 <alltraps>

80105ef4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $110
80105ef6:	6a 6e                	push   $0x6e
  jmp alltraps
80105ef8:	e9 79 f7 ff ff       	jmp    80105676 <alltraps>

80105efd <vector111>:
.globl vector111
vector111:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $111
80105eff:	6a 6f                	push   $0x6f
  jmp alltraps
80105f01:	e9 70 f7 ff ff       	jmp    80105676 <alltraps>

80105f06 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $112
80105f08:	6a 70                	push   $0x70
  jmp alltraps
80105f0a:	e9 67 f7 ff ff       	jmp    80105676 <alltraps>

80105f0f <vector113>:
.globl vector113
vector113:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $113
80105f11:	6a 71                	push   $0x71
  jmp alltraps
80105f13:	e9 5e f7 ff ff       	jmp    80105676 <alltraps>

80105f18 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $114
80105f1a:	6a 72                	push   $0x72
  jmp alltraps
80105f1c:	e9 55 f7 ff ff       	jmp    80105676 <alltraps>

80105f21 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $115
80105f23:	6a 73                	push   $0x73
  jmp alltraps
80105f25:	e9 4c f7 ff ff       	jmp    80105676 <alltraps>

80105f2a <vector116>:
.globl vector116
vector116:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $116
80105f2c:	6a 74                	push   $0x74
  jmp alltraps
80105f2e:	e9 43 f7 ff ff       	jmp    80105676 <alltraps>

80105f33 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $117
80105f35:	6a 75                	push   $0x75
  jmp alltraps
80105f37:	e9 3a f7 ff ff       	jmp    80105676 <alltraps>

80105f3c <vector118>:
.globl vector118
vector118:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $118
80105f3e:	6a 76                	push   $0x76
  jmp alltraps
80105f40:	e9 31 f7 ff ff       	jmp    80105676 <alltraps>

80105f45 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $119
80105f47:	6a 77                	push   $0x77
  jmp alltraps
80105f49:	e9 28 f7 ff ff       	jmp    80105676 <alltraps>

80105f4e <vector120>:
.globl vector120
vector120:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $120
80105f50:	6a 78                	push   $0x78
  jmp alltraps
80105f52:	e9 1f f7 ff ff       	jmp    80105676 <alltraps>

80105f57 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $121
80105f59:	6a 79                	push   $0x79
  jmp alltraps
80105f5b:	e9 16 f7 ff ff       	jmp    80105676 <alltraps>

80105f60 <vector122>:
.globl vector122
vector122:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $122
80105f62:	6a 7a                	push   $0x7a
  jmp alltraps
80105f64:	e9 0d f7 ff ff       	jmp    80105676 <alltraps>

80105f69 <vector123>:
.globl vector123
vector123:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $123
80105f6b:	6a 7b                	push   $0x7b
  jmp alltraps
80105f6d:	e9 04 f7 ff ff       	jmp    80105676 <alltraps>

80105f72 <vector124>:
.globl vector124
vector124:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $124
80105f74:	6a 7c                	push   $0x7c
  jmp alltraps
80105f76:	e9 fb f6 ff ff       	jmp    80105676 <alltraps>

80105f7b <vector125>:
.globl vector125
vector125:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $125
80105f7d:	6a 7d                	push   $0x7d
  jmp alltraps
80105f7f:	e9 f2 f6 ff ff       	jmp    80105676 <alltraps>

80105f84 <vector126>:
.globl vector126
vector126:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $126
80105f86:	6a 7e                	push   $0x7e
  jmp alltraps
80105f88:	e9 e9 f6 ff ff       	jmp    80105676 <alltraps>

80105f8d <vector127>:
.globl vector127
vector127:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $127
80105f8f:	6a 7f                	push   $0x7f
  jmp alltraps
80105f91:	e9 e0 f6 ff ff       	jmp    80105676 <alltraps>

80105f96 <vector128>:
.globl vector128
vector128:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $128
80105f98:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105f9d:	e9 d4 f6 ff ff       	jmp    80105676 <alltraps>

80105fa2 <vector129>:
.globl vector129
vector129:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $129
80105fa4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105fa9:	e9 c8 f6 ff ff       	jmp    80105676 <alltraps>

80105fae <vector130>:
.globl vector130
vector130:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $130
80105fb0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105fb5:	e9 bc f6 ff ff       	jmp    80105676 <alltraps>

80105fba <vector131>:
.globl vector131
vector131:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $131
80105fbc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105fc1:	e9 b0 f6 ff ff       	jmp    80105676 <alltraps>

80105fc6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $132
80105fc8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105fcd:	e9 a4 f6 ff ff       	jmp    80105676 <alltraps>

80105fd2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $133
80105fd4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105fd9:	e9 98 f6 ff ff       	jmp    80105676 <alltraps>

80105fde <vector134>:
.globl vector134
vector134:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $134
80105fe0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105fe5:	e9 8c f6 ff ff       	jmp    80105676 <alltraps>

80105fea <vector135>:
.globl vector135
vector135:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $135
80105fec:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105ff1:	e9 80 f6 ff ff       	jmp    80105676 <alltraps>

80105ff6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $136
80105ff8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ffd:	e9 74 f6 ff ff       	jmp    80105676 <alltraps>

80106002 <vector137>:
.globl vector137
vector137:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $137
80106004:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106009:	e9 68 f6 ff ff       	jmp    80105676 <alltraps>

8010600e <vector138>:
.globl vector138
vector138:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $138
80106010:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106015:	e9 5c f6 ff ff       	jmp    80105676 <alltraps>

8010601a <vector139>:
.globl vector139
vector139:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $139
8010601c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106021:	e9 50 f6 ff ff       	jmp    80105676 <alltraps>

80106026 <vector140>:
.globl vector140
vector140:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $140
80106028:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010602d:	e9 44 f6 ff ff       	jmp    80105676 <alltraps>

80106032 <vector141>:
.globl vector141
vector141:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $141
80106034:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106039:	e9 38 f6 ff ff       	jmp    80105676 <alltraps>

8010603e <vector142>:
.globl vector142
vector142:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $142
80106040:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106045:	e9 2c f6 ff ff       	jmp    80105676 <alltraps>

8010604a <vector143>:
.globl vector143
vector143:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $143
8010604c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106051:	e9 20 f6 ff ff       	jmp    80105676 <alltraps>

80106056 <vector144>:
.globl vector144
vector144:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $144
80106058:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010605d:	e9 14 f6 ff ff       	jmp    80105676 <alltraps>

80106062 <vector145>:
.globl vector145
vector145:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $145
80106064:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106069:	e9 08 f6 ff ff       	jmp    80105676 <alltraps>

8010606e <vector146>:
.globl vector146
vector146:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $146
80106070:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106075:	e9 fc f5 ff ff       	jmp    80105676 <alltraps>

8010607a <vector147>:
.globl vector147
vector147:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $147
8010607c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106081:	e9 f0 f5 ff ff       	jmp    80105676 <alltraps>

80106086 <vector148>:
.globl vector148
vector148:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $148
80106088:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010608d:	e9 e4 f5 ff ff       	jmp    80105676 <alltraps>

80106092 <vector149>:
.globl vector149
vector149:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $149
80106094:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106099:	e9 d8 f5 ff ff       	jmp    80105676 <alltraps>

8010609e <vector150>:
.globl vector150
vector150:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $150
801060a0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060a5:	e9 cc f5 ff ff       	jmp    80105676 <alltraps>

801060aa <vector151>:
.globl vector151
vector151:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $151
801060ac:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801060b1:	e9 c0 f5 ff ff       	jmp    80105676 <alltraps>

801060b6 <vector152>:
.globl vector152
vector152:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $152
801060b8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801060bd:	e9 b4 f5 ff ff       	jmp    80105676 <alltraps>

801060c2 <vector153>:
.globl vector153
vector153:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $153
801060c4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801060c9:	e9 a8 f5 ff ff       	jmp    80105676 <alltraps>

801060ce <vector154>:
.globl vector154
vector154:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $154
801060d0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801060d5:	e9 9c f5 ff ff       	jmp    80105676 <alltraps>

801060da <vector155>:
.globl vector155
vector155:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $155
801060dc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801060e1:	e9 90 f5 ff ff       	jmp    80105676 <alltraps>

801060e6 <vector156>:
.globl vector156
vector156:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $156
801060e8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801060ed:	e9 84 f5 ff ff       	jmp    80105676 <alltraps>

801060f2 <vector157>:
.globl vector157
vector157:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $157
801060f4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801060f9:	e9 78 f5 ff ff       	jmp    80105676 <alltraps>

801060fe <vector158>:
.globl vector158
vector158:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $158
80106100:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106105:	e9 6c f5 ff ff       	jmp    80105676 <alltraps>

8010610a <vector159>:
.globl vector159
vector159:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $159
8010610c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106111:	e9 60 f5 ff ff       	jmp    80105676 <alltraps>

80106116 <vector160>:
.globl vector160
vector160:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $160
80106118:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010611d:	e9 54 f5 ff ff       	jmp    80105676 <alltraps>

80106122 <vector161>:
.globl vector161
vector161:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $161
80106124:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106129:	e9 48 f5 ff ff       	jmp    80105676 <alltraps>

8010612e <vector162>:
.globl vector162
vector162:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $162
80106130:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106135:	e9 3c f5 ff ff       	jmp    80105676 <alltraps>

8010613a <vector163>:
.globl vector163
vector163:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $163
8010613c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106141:	e9 30 f5 ff ff       	jmp    80105676 <alltraps>

80106146 <vector164>:
.globl vector164
vector164:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $164
80106148:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010614d:	e9 24 f5 ff ff       	jmp    80105676 <alltraps>

80106152 <vector165>:
.globl vector165
vector165:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $165
80106154:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106159:	e9 18 f5 ff ff       	jmp    80105676 <alltraps>

8010615e <vector166>:
.globl vector166
vector166:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $166
80106160:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106165:	e9 0c f5 ff ff       	jmp    80105676 <alltraps>

8010616a <vector167>:
.globl vector167
vector167:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $167
8010616c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106171:	e9 00 f5 ff ff       	jmp    80105676 <alltraps>

80106176 <vector168>:
.globl vector168
vector168:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $168
80106178:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010617d:	e9 f4 f4 ff ff       	jmp    80105676 <alltraps>

80106182 <vector169>:
.globl vector169
vector169:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $169
80106184:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106189:	e9 e8 f4 ff ff       	jmp    80105676 <alltraps>

8010618e <vector170>:
.globl vector170
vector170:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $170
80106190:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106195:	e9 dc f4 ff ff       	jmp    80105676 <alltraps>

8010619a <vector171>:
.globl vector171
vector171:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $171
8010619c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061a1:	e9 d0 f4 ff ff       	jmp    80105676 <alltraps>

801061a6 <vector172>:
.globl vector172
vector172:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $172
801061a8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061ad:	e9 c4 f4 ff ff       	jmp    80105676 <alltraps>

801061b2 <vector173>:
.globl vector173
vector173:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $173
801061b4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801061b9:	e9 b8 f4 ff ff       	jmp    80105676 <alltraps>

801061be <vector174>:
.globl vector174
vector174:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $174
801061c0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801061c5:	e9 ac f4 ff ff       	jmp    80105676 <alltraps>

801061ca <vector175>:
.globl vector175
vector175:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $175
801061cc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801061d1:	e9 a0 f4 ff ff       	jmp    80105676 <alltraps>

801061d6 <vector176>:
.globl vector176
vector176:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $176
801061d8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801061dd:	e9 94 f4 ff ff       	jmp    80105676 <alltraps>

801061e2 <vector177>:
.globl vector177
vector177:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $177
801061e4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801061e9:	e9 88 f4 ff ff       	jmp    80105676 <alltraps>

801061ee <vector178>:
.globl vector178
vector178:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $178
801061f0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801061f5:	e9 7c f4 ff ff       	jmp    80105676 <alltraps>

801061fa <vector179>:
.globl vector179
vector179:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $179
801061fc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106201:	e9 70 f4 ff ff       	jmp    80105676 <alltraps>

80106206 <vector180>:
.globl vector180
vector180:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $180
80106208:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010620d:	e9 64 f4 ff ff       	jmp    80105676 <alltraps>

80106212 <vector181>:
.globl vector181
vector181:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $181
80106214:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106219:	e9 58 f4 ff ff       	jmp    80105676 <alltraps>

8010621e <vector182>:
.globl vector182
vector182:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $182
80106220:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106225:	e9 4c f4 ff ff       	jmp    80105676 <alltraps>

8010622a <vector183>:
.globl vector183
vector183:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $183
8010622c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106231:	e9 40 f4 ff ff       	jmp    80105676 <alltraps>

80106236 <vector184>:
.globl vector184
vector184:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $184
80106238:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010623d:	e9 34 f4 ff ff       	jmp    80105676 <alltraps>

80106242 <vector185>:
.globl vector185
vector185:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $185
80106244:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106249:	e9 28 f4 ff ff       	jmp    80105676 <alltraps>

8010624e <vector186>:
.globl vector186
vector186:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $186
80106250:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106255:	e9 1c f4 ff ff       	jmp    80105676 <alltraps>

8010625a <vector187>:
.globl vector187
vector187:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $187
8010625c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106261:	e9 10 f4 ff ff       	jmp    80105676 <alltraps>

80106266 <vector188>:
.globl vector188
vector188:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $188
80106268:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010626d:	e9 04 f4 ff ff       	jmp    80105676 <alltraps>

80106272 <vector189>:
.globl vector189
vector189:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $189
80106274:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106279:	e9 f8 f3 ff ff       	jmp    80105676 <alltraps>

8010627e <vector190>:
.globl vector190
vector190:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $190
80106280:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106285:	e9 ec f3 ff ff       	jmp    80105676 <alltraps>

8010628a <vector191>:
.globl vector191
vector191:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $191
8010628c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106291:	e9 e0 f3 ff ff       	jmp    80105676 <alltraps>

80106296 <vector192>:
.globl vector192
vector192:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $192
80106298:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010629d:	e9 d4 f3 ff ff       	jmp    80105676 <alltraps>

801062a2 <vector193>:
.globl vector193
vector193:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $193
801062a4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062a9:	e9 c8 f3 ff ff       	jmp    80105676 <alltraps>

801062ae <vector194>:
.globl vector194
vector194:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $194
801062b0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801062b5:	e9 bc f3 ff ff       	jmp    80105676 <alltraps>

801062ba <vector195>:
.globl vector195
vector195:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $195
801062bc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801062c1:	e9 b0 f3 ff ff       	jmp    80105676 <alltraps>

801062c6 <vector196>:
.globl vector196
vector196:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $196
801062c8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801062cd:	e9 a4 f3 ff ff       	jmp    80105676 <alltraps>

801062d2 <vector197>:
.globl vector197
vector197:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $197
801062d4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801062d9:	e9 98 f3 ff ff       	jmp    80105676 <alltraps>

801062de <vector198>:
.globl vector198
vector198:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $198
801062e0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801062e5:	e9 8c f3 ff ff       	jmp    80105676 <alltraps>

801062ea <vector199>:
.globl vector199
vector199:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $199
801062ec:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801062f1:	e9 80 f3 ff ff       	jmp    80105676 <alltraps>

801062f6 <vector200>:
.globl vector200
vector200:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $200
801062f8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801062fd:	e9 74 f3 ff ff       	jmp    80105676 <alltraps>

80106302 <vector201>:
.globl vector201
vector201:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $201
80106304:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106309:	e9 68 f3 ff ff       	jmp    80105676 <alltraps>

8010630e <vector202>:
.globl vector202
vector202:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $202
80106310:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106315:	e9 5c f3 ff ff       	jmp    80105676 <alltraps>

8010631a <vector203>:
.globl vector203
vector203:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $203
8010631c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106321:	e9 50 f3 ff ff       	jmp    80105676 <alltraps>

80106326 <vector204>:
.globl vector204
vector204:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $204
80106328:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010632d:	e9 44 f3 ff ff       	jmp    80105676 <alltraps>

80106332 <vector205>:
.globl vector205
vector205:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $205
80106334:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106339:	e9 38 f3 ff ff       	jmp    80105676 <alltraps>

8010633e <vector206>:
.globl vector206
vector206:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $206
80106340:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106345:	e9 2c f3 ff ff       	jmp    80105676 <alltraps>

8010634a <vector207>:
.globl vector207
vector207:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $207
8010634c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106351:	e9 20 f3 ff ff       	jmp    80105676 <alltraps>

80106356 <vector208>:
.globl vector208
vector208:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $208
80106358:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010635d:	e9 14 f3 ff ff       	jmp    80105676 <alltraps>

80106362 <vector209>:
.globl vector209
vector209:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $209
80106364:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106369:	e9 08 f3 ff ff       	jmp    80105676 <alltraps>

8010636e <vector210>:
.globl vector210
vector210:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $210
80106370:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106375:	e9 fc f2 ff ff       	jmp    80105676 <alltraps>

8010637a <vector211>:
.globl vector211
vector211:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $211
8010637c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106381:	e9 f0 f2 ff ff       	jmp    80105676 <alltraps>

80106386 <vector212>:
.globl vector212
vector212:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $212
80106388:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010638d:	e9 e4 f2 ff ff       	jmp    80105676 <alltraps>

80106392 <vector213>:
.globl vector213
vector213:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $213
80106394:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106399:	e9 d8 f2 ff ff       	jmp    80105676 <alltraps>

8010639e <vector214>:
.globl vector214
vector214:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $214
801063a0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063a5:	e9 cc f2 ff ff       	jmp    80105676 <alltraps>

801063aa <vector215>:
.globl vector215
vector215:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $215
801063ac:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801063b1:	e9 c0 f2 ff ff       	jmp    80105676 <alltraps>

801063b6 <vector216>:
.globl vector216
vector216:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $216
801063b8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801063bd:	e9 b4 f2 ff ff       	jmp    80105676 <alltraps>

801063c2 <vector217>:
.globl vector217
vector217:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $217
801063c4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801063c9:	e9 a8 f2 ff ff       	jmp    80105676 <alltraps>

801063ce <vector218>:
.globl vector218
vector218:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $218
801063d0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801063d5:	e9 9c f2 ff ff       	jmp    80105676 <alltraps>

801063da <vector219>:
.globl vector219
vector219:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $219
801063dc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801063e1:	e9 90 f2 ff ff       	jmp    80105676 <alltraps>

801063e6 <vector220>:
.globl vector220
vector220:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $220
801063e8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801063ed:	e9 84 f2 ff ff       	jmp    80105676 <alltraps>

801063f2 <vector221>:
.globl vector221
vector221:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $221
801063f4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801063f9:	e9 78 f2 ff ff       	jmp    80105676 <alltraps>

801063fe <vector222>:
.globl vector222
vector222:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $222
80106400:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106405:	e9 6c f2 ff ff       	jmp    80105676 <alltraps>

8010640a <vector223>:
.globl vector223
vector223:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $223
8010640c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106411:	e9 60 f2 ff ff       	jmp    80105676 <alltraps>

80106416 <vector224>:
.globl vector224
vector224:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $224
80106418:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010641d:	e9 54 f2 ff ff       	jmp    80105676 <alltraps>

80106422 <vector225>:
.globl vector225
vector225:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $225
80106424:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106429:	e9 48 f2 ff ff       	jmp    80105676 <alltraps>

8010642e <vector226>:
.globl vector226
vector226:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $226
80106430:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106435:	e9 3c f2 ff ff       	jmp    80105676 <alltraps>

8010643a <vector227>:
.globl vector227
vector227:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $227
8010643c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106441:	e9 30 f2 ff ff       	jmp    80105676 <alltraps>

80106446 <vector228>:
.globl vector228
vector228:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $228
80106448:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010644d:	e9 24 f2 ff ff       	jmp    80105676 <alltraps>

80106452 <vector229>:
.globl vector229
vector229:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $229
80106454:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106459:	e9 18 f2 ff ff       	jmp    80105676 <alltraps>

8010645e <vector230>:
.globl vector230
vector230:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $230
80106460:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106465:	e9 0c f2 ff ff       	jmp    80105676 <alltraps>

8010646a <vector231>:
.globl vector231
vector231:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $231
8010646c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106471:	e9 00 f2 ff ff       	jmp    80105676 <alltraps>

80106476 <vector232>:
.globl vector232
vector232:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $232
80106478:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010647d:	e9 f4 f1 ff ff       	jmp    80105676 <alltraps>

80106482 <vector233>:
.globl vector233
vector233:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $233
80106484:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106489:	e9 e8 f1 ff ff       	jmp    80105676 <alltraps>

8010648e <vector234>:
.globl vector234
vector234:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $234
80106490:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106495:	e9 dc f1 ff ff       	jmp    80105676 <alltraps>

8010649a <vector235>:
.globl vector235
vector235:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $235
8010649c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064a1:	e9 d0 f1 ff ff       	jmp    80105676 <alltraps>

801064a6 <vector236>:
.globl vector236
vector236:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $236
801064a8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064ad:	e9 c4 f1 ff ff       	jmp    80105676 <alltraps>

801064b2 <vector237>:
.globl vector237
vector237:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $237
801064b4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801064b9:	e9 b8 f1 ff ff       	jmp    80105676 <alltraps>

801064be <vector238>:
.globl vector238
vector238:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $238
801064c0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801064c5:	e9 ac f1 ff ff       	jmp    80105676 <alltraps>

801064ca <vector239>:
.globl vector239
vector239:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $239
801064cc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801064d1:	e9 a0 f1 ff ff       	jmp    80105676 <alltraps>

801064d6 <vector240>:
.globl vector240
vector240:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $240
801064d8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801064dd:	e9 94 f1 ff ff       	jmp    80105676 <alltraps>

801064e2 <vector241>:
.globl vector241
vector241:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $241
801064e4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801064e9:	e9 88 f1 ff ff       	jmp    80105676 <alltraps>

801064ee <vector242>:
.globl vector242
vector242:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $242
801064f0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801064f5:	e9 7c f1 ff ff       	jmp    80105676 <alltraps>

801064fa <vector243>:
.globl vector243
vector243:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $243
801064fc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106501:	e9 70 f1 ff ff       	jmp    80105676 <alltraps>

80106506 <vector244>:
.globl vector244
vector244:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $244
80106508:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010650d:	e9 64 f1 ff ff       	jmp    80105676 <alltraps>

80106512 <vector245>:
.globl vector245
vector245:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $245
80106514:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106519:	e9 58 f1 ff ff       	jmp    80105676 <alltraps>

8010651e <vector246>:
.globl vector246
vector246:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $246
80106520:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106525:	e9 4c f1 ff ff       	jmp    80105676 <alltraps>

8010652a <vector247>:
.globl vector247
vector247:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $247
8010652c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106531:	e9 40 f1 ff ff       	jmp    80105676 <alltraps>

80106536 <vector248>:
.globl vector248
vector248:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $248
80106538:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010653d:	e9 34 f1 ff ff       	jmp    80105676 <alltraps>

80106542 <vector249>:
.globl vector249
vector249:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $249
80106544:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106549:	e9 28 f1 ff ff       	jmp    80105676 <alltraps>

8010654e <vector250>:
.globl vector250
vector250:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $250
80106550:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106555:	e9 1c f1 ff ff       	jmp    80105676 <alltraps>

8010655a <vector251>:
.globl vector251
vector251:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $251
8010655c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106561:	e9 10 f1 ff ff       	jmp    80105676 <alltraps>

80106566 <vector252>:
.globl vector252
vector252:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $252
80106568:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010656d:	e9 04 f1 ff ff       	jmp    80105676 <alltraps>

80106572 <vector253>:
.globl vector253
vector253:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $253
80106574:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106579:	e9 f8 f0 ff ff       	jmp    80105676 <alltraps>

8010657e <vector254>:
.globl vector254
vector254:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $254
80106580:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106585:	e9 ec f0 ff ff       	jmp    80105676 <alltraps>

8010658a <vector255>:
.globl vector255
vector255:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $255
8010658c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106591:	e9 e0 f0 ff ff       	jmp    80105676 <alltraps>
80106596:	66 90                	xchg   %ax,%ax
80106598:	66 90                	xchg   %ax,%ax
8010659a:	66 90                	xchg   %ax,%ax
8010659c:	66 90                	xchg   %ax,%ax
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065a7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065aa:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065ae:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801065b1:	8b 1f                	mov    (%edi),%ebx
801065b3:	f6 c3 01             	test   $0x1,%bl
801065b6:	74 28                	je     801065e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801065b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801065be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801065c4:	c1 ee 0a             	shr    $0xa,%esi
}
801065c7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801065ca:	89 f2                	mov    %esi,%edx
801065cc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801065d2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801065d5:	5b                   	pop    %ebx
801065d6:	5e                   	pop    %esi
801065d7:	5f                   	pop    %edi
801065d8:	5d                   	pop    %ebp
801065d9:	c3                   	ret    
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801065e0:	85 c9                	test   %ecx,%ecx
801065e2:	74 34                	je     80106618 <walkpgdir+0x78>
801065e4:	e8 c7 be ff ff       	call   801024b0 <kalloc>
801065e9:	85 c0                	test   %eax,%eax
801065eb:	89 c3                	mov    %eax,%ebx
801065ed:	74 29                	je     80106618 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801065ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801065f6:	00 
801065f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065fe:	00 
801065ff:	89 04 24             	mov    %eax,(%esp)
80106602:	e8 79 de ff ff       	call   80104480 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106607:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010660d:	83 c8 07             	or     $0x7,%eax
80106610:	89 07                	mov    %eax,(%edi)
80106612:	eb b0                	jmp    801065c4 <walkpgdir+0x24>
80106614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106618:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010661b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010661d:	5b                   	pop    %ebx
8010661e:	5e                   	pop    %esi
8010661f:	5f                   	pop    %edi
80106620:	5d                   	pop    %ebp
80106621:	c3                   	ret    
80106622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106630 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	57                   	push   %edi
80106634:	56                   	push   %esi
80106635:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106636:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106638:	83 ec 1c             	sub    $0x1c,%esp
8010663b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010663e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106644:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106647:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010664b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010664e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106652:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106659:	29 df                	sub    %ebx,%edi
8010665b:	eb 18                	jmp    80106675 <mappages+0x45>
8010665d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106660:	f6 00 01             	testb  $0x1,(%eax)
80106663:	75 3d                	jne    801066a2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106665:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106668:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010666b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010666d:	74 29                	je     80106698 <mappages+0x68>
      break;
    a += PGSIZE;
8010666f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106675:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106678:	b9 01 00 00 00       	mov    $0x1,%ecx
8010667d:	89 da                	mov    %ebx,%edx
8010667f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106682:	e8 19 ff ff ff       	call   801065a0 <walkpgdir>
80106687:	85 c0                	test   %eax,%eax
80106689:	75 d5                	jne    80106660 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010668b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010668e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106693:	5b                   	pop    %ebx
80106694:	5e                   	pop    %esi
80106695:	5f                   	pop    %edi
80106696:	5d                   	pop    %ebp
80106697:	c3                   	ret    
80106698:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010669b:	31 c0                	xor    %eax,%eax
}
8010669d:	5b                   	pop    %ebx
8010669e:	5e                   	pop    %esi
8010669f:	5f                   	pop    %edi
801066a0:	5d                   	pop    %ebp
801066a1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801066a2:	c7 04 24 90 77 10 80 	movl   $0x80107790,(%esp)
801066a9:	e8 b2 9c ff ff       	call   80100360 <panic>
801066ae:	66 90                	xchg   %ax,%ax

801066b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	89 c7                	mov    %eax,%edi
801066b6:	56                   	push   %esi
801066b7:	89 d6                	mov    %edx,%esi
801066b9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066ba:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066c0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066c3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801066c9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066ce:	72 3b                	jb     8010670b <deallocuvm.part.0+0x5b>
801066d0:	eb 5e                	jmp    80106730 <deallocuvm.part.0+0x80>
801066d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801066d8:	8b 10                	mov    (%eax),%edx
801066da:	f6 c2 01             	test   $0x1,%dl
801066dd:	74 22                	je     80106701 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801066df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801066e5:	74 54                	je     8010673b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801066e7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801066ed:	89 14 24             	mov    %edx,(%esp)
801066f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066f3:	e8 08 bc ff ff       	call   80102300 <kfree>
      *pte = 0;
801066f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106701:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106707:	39 f3                	cmp    %esi,%ebx
80106709:	73 25                	jae    80106730 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010670b:	31 c9                	xor    %ecx,%ecx
8010670d:	89 da                	mov    %ebx,%edx
8010670f:	89 f8                	mov    %edi,%eax
80106711:	e8 8a fe ff ff       	call   801065a0 <walkpgdir>
    if(!pte)
80106716:	85 c0                	test   %eax,%eax
80106718:	75 be                	jne    801066d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010671a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106720:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106726:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010672c:	39 f3                	cmp    %esi,%ebx
8010672e:	72 db                	jb     8010670b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106730:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106733:	83 c4 1c             	add    $0x1c,%esp
80106736:	5b                   	pop    %ebx
80106737:	5e                   	pop    %esi
80106738:	5f                   	pop    %edi
80106739:	5d                   	pop    %ebp
8010673a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010673b:	c7 04 24 26 71 10 80 	movl   $0x80107126,(%esp)
80106742:	e8 19 9c ff ff       	call   80100360 <panic>
80106747:	89 f6                	mov    %esi,%esi
80106749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106750 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106756:	e8 45 cf ff ff       	call   801036a0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010675b:	31 c9                	xor    %ecx,%ecx
8010675d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106762:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106768:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010676d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106771:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106776:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106779:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010677d:	31 c9                	xor    %ecx,%ecx
8010677f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106783:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106788:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010678c:	31 c9                	xor    %ecx,%ecx
8010678e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106792:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106797:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010679b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010679d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801067a1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067a5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801067a9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067ad:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801067b1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067b5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801067b9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801067bd:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801067c1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067c6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801067ca:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067ce:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801067d2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067d6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801067da:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067de:	66 89 48 22          	mov    %cx,0x22(%eax)
801067e2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801067e6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801067ea:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801067ee:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067f2:	c1 e8 10             	shr    $0x10,%eax
801067f5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801067f9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801067fc:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
801067ff:	c9                   	leave  
80106800:	c3                   	ret    
80106801:	eb 0d                	jmp    80106810 <switchkvm>
80106803:	90                   	nop
80106804:	90                   	nop
80106805:	90                   	nop
80106806:	90                   	nop
80106807:	90                   	nop
80106808:	90                   	nop
80106809:	90                   	nop
8010680a:	90                   	nop
8010680b:	90                   	nop
8010680c:	90                   	nop
8010680d:	90                   	nop
8010680e:	90                   	nop
8010680f:	90                   	nop

80106810 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106810:	a1 a4 58 11 80       	mov    0x801158a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106815:	55                   	push   %ebp
80106816:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106818:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010681d:	0f 22 d8             	mov    %eax,%cr3
}
80106820:	5d                   	pop    %ebp
80106821:	c3                   	ret    
80106822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
80106836:	83 ec 1c             	sub    $0x1c,%esp
80106839:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010683c:	85 f6                	test   %esi,%esi
8010683e:	0f 84 cd 00 00 00    	je     80106911 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106844:	8b 46 08             	mov    0x8(%esi),%eax
80106847:	85 c0                	test   %eax,%eax
80106849:	0f 84 da 00 00 00    	je     80106929 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010684f:	8b 7e 04             	mov    0x4(%esi),%edi
80106852:	85 ff                	test   %edi,%edi
80106854:	0f 84 c3 00 00 00    	je     8010691d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
8010685a:	e8 a1 da ff ff       	call   80104300 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010685f:	e8 bc cd ff ff       	call   80103620 <mycpu>
80106864:	89 c3                	mov    %eax,%ebx
80106866:	e8 b5 cd ff ff       	call   80103620 <mycpu>
8010686b:	89 c7                	mov    %eax,%edi
8010686d:	e8 ae cd ff ff       	call   80103620 <mycpu>
80106872:	83 c7 08             	add    $0x8,%edi
80106875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106878:	e8 a3 cd ff ff       	call   80103620 <mycpu>
8010687d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106880:	ba 67 00 00 00       	mov    $0x67,%edx
80106885:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010688c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106893:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010689a:	83 c1 08             	add    $0x8,%ecx
8010689d:	c1 e9 10             	shr    $0x10,%ecx
801068a0:	83 c0 08             	add    $0x8,%eax
801068a3:	c1 e8 18             	shr    $0x18,%eax
801068a6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801068ac:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801068b3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801068b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801068be:	e8 5d cd ff ff       	call   80103620 <mycpu>
801068c3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801068ca:	e8 51 cd ff ff       	call   80103620 <mycpu>
801068cf:	b9 10 00 00 00       	mov    $0x10,%ecx
801068d4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068d8:	e8 43 cd ff ff       	call   80103620 <mycpu>
801068dd:	8b 56 08             	mov    0x8(%esi),%edx
801068e0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801068e6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801068e9:	e8 32 cd ff ff       	call   80103620 <mycpu>
801068ee:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801068f2:	b8 28 00 00 00       	mov    $0x28,%eax
801068f7:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801068fa:	8b 46 04             	mov    0x4(%esi),%eax
801068fd:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106902:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106905:	83 c4 1c             	add    $0x1c,%esp
80106908:	5b                   	pop    %ebx
80106909:	5e                   	pop    %esi
8010690a:	5f                   	pop    %edi
8010690b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010690c:	e9 af da ff ff       	jmp    801043c0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106911:	c7 04 24 96 77 10 80 	movl   $0x80107796,(%esp)
80106918:	e8 43 9a ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010691d:	c7 04 24 c1 77 10 80 	movl   $0x801077c1,(%esp)
80106924:	e8 37 9a ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106929:	c7 04 24 ac 77 10 80 	movl   $0x801077ac,(%esp)
80106930:	e8 2b 9a ff ff       	call   80100360 <panic>
80106935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106940 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
80106946:	83 ec 1c             	sub    $0x1c,%esp
80106949:	8b 75 10             	mov    0x10(%ebp),%esi
8010694c:	8b 45 08             	mov    0x8(%ebp),%eax
8010694f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106952:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010695b:	77 54                	ja     801069b1 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010695d:	e8 4e bb ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106962:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106969:	00 
8010696a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106971:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106972:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106974:	89 04 24             	mov    %eax,(%esp)
80106977:	e8 04 db ff ff       	call   80104480 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010697c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106982:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106987:	89 04 24             	mov    %eax,(%esp)
8010698a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010698d:	31 d2                	xor    %edx,%edx
8010698f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106996:	00 
80106997:	e8 94 fc ff ff       	call   80106630 <mappages>
  memmove(mem, init, sz);
8010699c:	89 75 10             	mov    %esi,0x10(%ebp)
8010699f:	89 7d 0c             	mov    %edi,0xc(%ebp)
801069a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801069a5:	83 c4 1c             	add    $0x1c,%esp
801069a8:	5b                   	pop    %ebx
801069a9:	5e                   	pop    %esi
801069aa:	5f                   	pop    %edi
801069ab:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801069ac:	e9 6f db ff ff       	jmp    80104520 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801069b1:	c7 04 24 d5 77 10 80 	movl   $0x801077d5,(%esp)
801069b8:	e8 a3 99 ff ff       	call   80100360 <panic>
801069bd:	8d 76 00             	lea    0x0(%esi),%esi

801069c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801069c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801069d0:	0f 85 98 00 00 00    	jne    80106a6e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801069d6:	8b 75 18             	mov    0x18(%ebp),%esi
801069d9:	31 db                	xor    %ebx,%ebx
801069db:	85 f6                	test   %esi,%esi
801069dd:	75 1a                	jne    801069f9 <loaduvm+0x39>
801069df:	eb 77                	jmp    80106a58 <loaduvm+0x98>
801069e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801069f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801069f7:	76 5f                	jbe    80106a58 <loaduvm+0x98>
801069f9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069fc:	31 c9                	xor    %ecx,%ecx
801069fe:	8b 45 08             	mov    0x8(%ebp),%eax
80106a01:	01 da                	add    %ebx,%edx
80106a03:	e8 98 fb ff ff       	call   801065a0 <walkpgdir>
80106a08:	85 c0                	test   %eax,%eax
80106a0a:	74 56                	je     80106a62 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a0c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106a0e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106a13:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106a1b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106a21:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a24:	05 00 00 00 80       	add    $0x80000000,%eax
80106a29:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a2d:	8b 45 10             	mov    0x10(%ebp),%eax
80106a30:	01 d9                	add    %ebx,%ecx
80106a32:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106a36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a3a:	89 04 24             	mov    %eax,(%esp)
80106a3d:	e8 2e af ff ff       	call   80101970 <readi>
80106a42:	39 f8                	cmp    %edi,%eax
80106a44:	74 a2                	je     801069e8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106a46:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106a4e:	5b                   	pop    %ebx
80106a4f:	5e                   	pop    %esi
80106a50:	5f                   	pop    %edi
80106a51:	5d                   	pop    %ebp
80106a52:	c3                   	ret    
80106a53:	90                   	nop
80106a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a58:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106a5b:	31 c0                	xor    %eax,%eax
}
80106a5d:	5b                   	pop    %ebx
80106a5e:	5e                   	pop    %esi
80106a5f:	5f                   	pop    %edi
80106a60:	5d                   	pop    %ebp
80106a61:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106a62:	c7 04 24 ef 77 10 80 	movl   $0x801077ef,(%esp)
80106a69:	e8 f2 98 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106a6e:	c7 04 24 90 78 10 80 	movl   $0x80107890,(%esp)
80106a75:	e8 e6 98 ff ff       	call   80100360 <panic>
80106a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a80 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
80106a86:	83 ec 1c             	sub    $0x1c,%esp
80106a89:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106a8c:	85 ff                	test   %edi,%edi
80106a8e:	0f 88 7e 00 00 00    	js     80106b12 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106a94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106a9a:	72 78                	jb     80106b14 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106a9c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106aa2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106aa8:	39 df                	cmp    %ebx,%edi
80106aaa:	77 4a                	ja     80106af6 <allocuvm+0x76>
80106aac:	eb 72                	jmp    80106b20 <allocuvm+0xa0>
80106aae:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106ab0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ab7:	00 
80106ab8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106abf:	00 
80106ac0:	89 04 24             	mov    %eax,(%esp)
80106ac3:	e8 b8 d9 ff ff       	call   80104480 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ac8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ace:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ad3:	89 04 24             	mov    %eax,(%esp)
80106ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad9:	89 da                	mov    %ebx,%edx
80106adb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106ae2:	00 
80106ae3:	e8 48 fb ff ff       	call   80106630 <mappages>
80106ae8:	85 c0                	test   %eax,%eax
80106aea:	78 44                	js     80106b30 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106aec:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106af2:	39 df                	cmp    %ebx,%edi
80106af4:	76 2a                	jbe    80106b20 <allocuvm+0xa0>
    mem = kalloc();
80106af6:	e8 b5 b9 ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
80106afb:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106afd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106aff:	75 af                	jne    80106ab0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106b01:	c7 04 24 0d 78 10 80 	movl   $0x8010780d,(%esp)
80106b08:	e8 43 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b0d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b10:	77 48                	ja     80106b5a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106b12:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106b14:	83 c4 1c             	add    $0x1c,%esp
80106b17:	5b                   	pop    %ebx
80106b18:	5e                   	pop    %esi
80106b19:	5f                   	pop    %edi
80106b1a:	5d                   	pop    %ebp
80106b1b:	c3                   	ret    
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b20:	83 c4 1c             	add    $0x1c,%esp
80106b23:	89 f8                	mov    %edi,%eax
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106b30:	c7 04 24 25 78 10 80 	movl   $0x80107825,(%esp)
80106b37:	e8 14 9b ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b3c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b3f:	76 0d                	jbe    80106b4e <allocuvm+0xce>
80106b41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b44:	89 fa                	mov    %edi,%edx
80106b46:	8b 45 08             	mov    0x8(%ebp),%eax
80106b49:	e8 62 fb ff ff       	call   801066b0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106b4e:	89 34 24             	mov    %esi,(%esp)
80106b51:	e8 aa b7 ff ff       	call   80102300 <kfree>
      return 0;
80106b56:	31 c0                	xor    %eax,%eax
80106b58:	eb ba                	jmp    80106b14 <allocuvm+0x94>
80106b5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b5d:	89 fa                	mov    %edi,%edx
80106b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b62:	e8 49 fb ff ff       	call   801066b0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106b67:	31 c0                	xor    %eax,%eax
80106b69:	eb a9                	jmp    80106b14 <allocuvm+0x94>
80106b6b:	90                   	nop
80106b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b70 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106b79:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b7c:	39 d1                	cmp    %edx,%ecx
80106b7e:	73 08                	jae    80106b88 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b80:	5d                   	pop    %ebp
80106b81:	e9 2a fb ff ff       	jmp    801066b0 <deallocuvm.part.0>
80106b86:	66 90                	xchg   %ax,%ax
80106b88:	89 d0                	mov    %edx,%eax
80106b8a:	5d                   	pop    %ebp
80106b8b:	c3                   	ret    
80106b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	56                   	push   %esi
80106b94:	53                   	push   %ebx
80106b95:	83 ec 10             	sub    $0x10,%esp
80106b98:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b9b:	85 f6                	test   %esi,%esi
80106b9d:	74 59                	je     80106bf8 <freevm+0x68>
80106b9f:	31 c9                	xor    %ecx,%ecx
80106ba1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ba6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ba8:	31 db                	xor    %ebx,%ebx
80106baa:	e8 01 fb ff ff       	call   801066b0 <deallocuvm.part.0>
80106baf:	eb 12                	jmp    80106bc3 <freevm+0x33>
80106bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb8:	83 c3 01             	add    $0x1,%ebx
80106bbb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106bc1:	74 27                	je     80106bea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106bc3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106bc6:	f6 c2 01             	test   $0x1,%dl
80106bc9:	74 ed                	je     80106bb8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106bcb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106bd1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106bd4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106bda:	89 14 24             	mov    %edx,(%esp)
80106bdd:	e8 1e b7 ff ff       	call   80102300 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106be2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106be8:	75 d9                	jne    80106bc3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106bea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106bed:	83 c4 10             	add    $0x10,%esp
80106bf0:	5b                   	pop    %ebx
80106bf1:	5e                   	pop    %esi
80106bf2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106bf3:	e9 08 b7 ff ff       	jmp    80102300 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106bf8:	c7 04 24 41 78 10 80 	movl   $0x80107841,(%esp)
80106bff:	e8 5c 97 ff ff       	call   80100360 <panic>
80106c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c10 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	56                   	push   %esi
80106c14:	53                   	push   %ebx
80106c15:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106c18:	e8 93 b8 ff ff       	call   801024b0 <kalloc>
80106c1d:	85 c0                	test   %eax,%eax
80106c1f:	89 c6                	mov    %eax,%esi
80106c21:	74 6d                	je     80106c90 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106c23:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c2a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c2b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106c30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c37:	00 
80106c38:	89 04 24             	mov    %eax,(%esp)
80106c3b:	e8 40 d8 ff ff       	call   80104480 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106c40:	8b 53 0c             	mov    0xc(%ebx),%edx
80106c43:	8b 43 04             	mov    0x4(%ebx),%eax
80106c46:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106c49:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c4d:	8b 13                	mov    (%ebx),%edx
80106c4f:	89 04 24             	mov    %eax,(%esp)
80106c52:	29 c1                	sub    %eax,%ecx
80106c54:	89 f0                	mov    %esi,%eax
80106c56:	e8 d5 f9 ff ff       	call   80106630 <mappages>
80106c5b:	85 c0                	test   %eax,%eax
80106c5d:	78 19                	js     80106c78 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c5f:	83 c3 10             	add    $0x10,%ebx
80106c62:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c68:	72 d6                	jb     80106c40 <setupkvm+0x30>
80106c6a:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106c6c:	83 c4 10             	add    $0x10,%esp
80106c6f:	5b                   	pop    %ebx
80106c70:	5e                   	pop    %esi
80106c71:	5d                   	pop    %ebp
80106c72:	c3                   	ret    
80106c73:	90                   	nop
80106c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106c78:	89 34 24             	mov    %esi,(%esp)
80106c7b:	e8 10 ff ff ff       	call   80106b90 <freevm>
      return 0;
    }
  return pgdir;
}
80106c80:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106c83:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5d                   	pop    %ebp
80106c88:	c3                   	ret    
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106c90:	31 c0                	xor    %eax,%eax
80106c92:	eb d8                	jmp    80106c6c <setupkvm+0x5c>
80106c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ca0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ca6:	e8 65 ff ff ff       	call   80106c10 <setupkvm>
80106cab:	a3 a4 58 11 80       	mov    %eax,0x801158a4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106cb5:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106cb8:	c9                   	leave  
80106cb9:	c3                   	ret    
80106cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106cc0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cc1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106cc3:	89 e5                	mov    %esp,%ebp
80106cc5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cce:	e8 cd f8 ff ff       	call   801065a0 <walkpgdir>
  if(pte == 0)
80106cd3:	85 c0                	test   %eax,%eax
80106cd5:	74 05                	je     80106cdc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106cd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106cda:	c9                   	leave  
80106cdb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106cdc:	c7 04 24 52 78 10 80 	movl   $0x80107852,(%esp)
80106ce3:	e8 78 96 ff ff       	call   80100360 <panic>
80106ce8:	90                   	nop
80106ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cf0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106cf9:	e8 12 ff ff ff       	call   80106c10 <setupkvm>
80106cfe:	85 c0                	test   %eax,%eax
80106d00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d03:	0f 84 b2 00 00 00    	je     80106dbb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d0c:	85 c0                	test   %eax,%eax
80106d0e:	0f 84 9c 00 00 00    	je     80106db0 <copyuvm+0xc0>
80106d14:	31 db                	xor    %ebx,%ebx
80106d16:	eb 48                	jmp    80106d60 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106d18:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106d1e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d25:	00 
80106d26:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106d2a:	89 04 24             	mov    %eax,(%esp)
80106d2d:	e8 ee d7 ff ff       	call   80104520 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d35:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106d3b:	89 14 24             	mov    %edx,(%esp)
80106d3e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d43:	89 da                	mov    %ebx,%edx
80106d45:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d4c:	e8 df f8 ff ff       	call   80106630 <mappages>
80106d51:	85 c0                	test   %eax,%eax
80106d53:	78 41                	js     80106d96 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d5b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106d5e:	76 50                	jbe    80106db0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
80106d63:	31 c9                	xor    %ecx,%ecx
80106d65:	89 da                	mov    %ebx,%edx
80106d67:	e8 34 f8 ff ff       	call   801065a0 <walkpgdir>
80106d6c:	85 c0                	test   %eax,%eax
80106d6e:	74 5b                	je     80106dcb <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106d70:	8b 30                	mov    (%eax),%esi
80106d72:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106d78:	74 45                	je     80106dbf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d7a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106d7c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106d82:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106d8b:	e8 20 b7 ff ff       	call   801024b0 <kalloc>
80106d90:	85 c0                	test   %eax,%eax
80106d92:	89 c6                	mov    %eax,%esi
80106d94:	75 82                	jne    80106d18 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d99:	89 04 24             	mov    %eax,(%esp)
80106d9c:	e8 ef fd ff ff       	call   80106b90 <freevm>
  return 0;
80106da1:	31 c0                	xor    %eax,%eax
}
80106da3:	83 c4 2c             	add    $0x2c,%esp
80106da6:	5b                   	pop    %ebx
80106da7:	5e                   	pop    %esi
80106da8:	5f                   	pop    %edi
80106da9:	5d                   	pop    %ebp
80106daa:	c3                   	ret    
80106dab:	90                   	nop
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106db3:	83 c4 2c             	add    $0x2c,%esp
80106db6:	5b                   	pop    %ebx
80106db7:	5e                   	pop    %esi
80106db8:	5f                   	pop    %edi
80106db9:	5d                   	pop    %ebp
80106dba:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106dbb:	31 c0                	xor    %eax,%eax
80106dbd:	eb e4                	jmp    80106da3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106dbf:	c7 04 24 76 78 10 80 	movl   $0x80107876,(%esp)
80106dc6:	e8 95 95 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106dcb:	c7 04 24 5c 78 10 80 	movl   $0x8010785c,(%esp)
80106dd2:	e8 89 95 ff ff       	call   80100360 <panic>
80106dd7:	89 f6                	mov    %esi,%esi
80106dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106de0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106de3:	89 e5                	mov    %esp,%ebp
80106de5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106deb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dee:	e8 ad f7 ff ff       	call   801065a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106df3:	8b 00                	mov    (%eax),%eax
80106df5:	89 c2                	mov    %eax,%edx
80106df7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106dfa:	83 fa 05             	cmp    $0x5,%edx
80106dfd:	75 11                	jne    80106e10 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106dff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e04:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106e09:	c9                   	leave  
80106e0a:	c3                   	ret    
80106e0b:	90                   	nop
80106e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106e10:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106e12:	c9                   	leave  
80106e13:	c3                   	ret    
80106e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e20 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e32:	85 db                	test   %ebx,%ebx
80106e34:	75 3a                	jne    80106e70 <copyout+0x50>
80106e36:	eb 68                	jmp    80106ea0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106e38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e3b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e3d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106e41:	29 ca                	sub    %ecx,%edx
80106e43:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106e49:	39 da                	cmp    %ebx,%edx
80106e4b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e4e:	29 f1                	sub    %esi,%ecx
80106e50:	01 c8                	add    %ecx,%eax
80106e52:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e56:	89 04 24             	mov    %eax,(%esp)
80106e59:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106e5c:	e8 bf d6 ff ff       	call   80104520 <memmove>
    len -= n;
    buf += n;
80106e61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106e64:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106e6a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e6c:	29 d3                	sub    %edx,%ebx
80106e6e:	74 30                	je     80106ea0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106e70:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e73:	89 ce                	mov    %ecx,%esi
80106e75:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e7f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106e82:	89 04 24             	mov    %eax,(%esp)
80106e85:	e8 56 ff ff ff       	call   80106de0 <uva2ka>
    if(pa0 == 0)
80106e8a:	85 c0                	test   %eax,%eax
80106e8c:	75 aa                	jne    80106e38 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e8e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e96:	5b                   	pop    %ebx
80106e97:	5e                   	pop    %esi
80106e98:	5f                   	pop    %edi
80106e99:	5d                   	pop    %ebp
80106e9a:	c3                   	ret    
80106e9b:	90                   	nop
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ea0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106ea3:	31 c0                	xor    %eax,%eax
}
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret    
